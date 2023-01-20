import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:place_picker/place_picker.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/firebase/user.dart';
import 'package:protestory/screens/protest_information_screen.dart';

import '../firebase/attender.dart';
import '../firebase/story.dart';
import '../firebase/update.dart';
import '../utils/exceptions.dart';

class DataProvider {
  static const version = '1.0.0-develop';
  static final firestore =
      FirebaseFirestore.instance.collection('versions').doc('v$version');
  static final firestorage = FirebaseStorage.instance.ref('v$version');
  static final geostore = Geoflutterfire();

  static final CollectionReference<Protest> protestsCollectionRef =
      firestore.collection('protests').withConverter(
            fromFirestore: Protest.fromFirestore,
            toFirestore: (Protest protest, _) => protest.toFirestore(),
          );
  late final CollectionReference<PUser> usersCollectionRef;
  late final CollectionReference<Attender> attendingCollectionRef;

  late PUser user;

  DataProvider(User fireUser) {
    usersCollectionRef = firestore.collection('users').withConverter(
        fromFirestore: PUser.fromFirestore,
        toFirestore: (PUser user, _) => user.toFirestore());
    syncUser(fireUser);

    attendingCollectionRef = firestore.collection('attending').withConverter(
          fromFirestore: Attender.fromFirestore,
          toFirestore: (Attender att, _) => att.toFirestore(),
        );
  }

  CollectionReference<Protest> get getProtestCollectionRef =>
      protestsCollectionRef;

  CollectionReference<Attender> get getAttendingCollectionRef =>
      attendingCollectionRef;

  Future<Protest> addProtest(
      {required String name,
      required DateTime date,
      required String contactInfo,
      required String description,
      required String location,
      required LatLng locationLatLng,
      required List<String> tags,
      required File image}) async {
    //creating doc to the protest
    var docRef = protestsCollectionRef.doc();
    Protest newProtest = Protest(
      id: docRef.id,
      name: name,
      date: Timestamp.fromDate(date),
      creator: user.id,
      creationTime: Timestamp.fromDate(DateTime.now()),
      participantsAmount: 0,
      contactInfo: contactInfo,
      description: description,
      locationName: location,
      locationLatLng: locationLatLng,
      tags: tags,
      links: [],
    );
    await firestorage.child('protests_images').child(docRef.id).putFile(image);
    await docRef.set(newProtest);

    return newProtest;
  }

  Future<Protest> updateProtest(
      {required Protest protest,
      required String name,
      required DateTime date,
      required String contactInfo,
      required String description,
      required String location,
      required LatLng locationLatLng,
      required List<String> tags,
      required File? image}) async {
    var docRef = protestsCollectionRef.doc(protest.id);
    Protest updatedProtest = Protest(
        id: protest.id,
        name: name,
        date: Timestamp.fromDate(date),
        creator: protest.creator,
        creationTime: protest.creationTime,
        participantsAmount: protest.participantsAmount,
        contactInfo: contactInfo,
        description: description,
        locationName: location,
        locationLatLng: locationLatLng,
        tags: tags,
        links: protest.links);
    if (image != null) {
      //if its null, we didnt update the image so we dont need to update firestorage
      await firestorage
          .child('protests_images')
          .child(protest.id)
          .putFile(image);
    }
    await docRef.set(updatedProtest, SetOptions(merge: true));
    return updatedProtest;
  }

  Future<void> deleteProtest(Protest protestToDelete) async {
    await firestorage
        .child('protests_images')
        .child(protestToDelete.id)
        .delete();
    var query = await getProtestAttenders(protestToDelete.id).get();
    for (var currDoc in query.docs) {
      currDoc.reference.delete();
    }

    var stories = await protestsCollectionRef
        .doc(protestToDelete.id)
        .collection("stories")
        .get();
    for (var doc in stories.docs) {
      doc.reference.collection("likes").get().then((likes) {
        for (var like in likes.docs) {
          like.reference.delete();
        }
      });
      doc.reference.delete();
    }

    var updates = await protestsCollectionRef
        .doc(protestToDelete.id)
        .collection("updates")
        .get();
    for (var doc in updates.docs) {
      doc.reference.delete();
    }

    return await protestsCollectionRef.doc(protestToDelete.id).delete();
  }

  Query<Attender> getProtestAttenders(String protestId) {
    return attendingCollectionRef.where('protest_id', isEqualTo: protestId);
  }

  //parameter is the name of the field we sorting by
  Future<List<Protest>> getNProtests(
      {required n,
      required String parameter,
      required bool isDescending}) async {
    List<Protest> protestList = [];
    var query = await protestsCollectionRef
        .orderBy(parameter, descending: isDescending)
        .limit(n)
        .get();

    for (var element in query.docs) {
      protestList.add(element.data());
    }

    return protestList;
  }

  Future<List<Protest>> getMostRecentProtests({
    required int n,
  }) async {
    return getNProtests(n: n, parameter: 'creation_time', isDescending: true);
  }

  Future<List<Protest>> getMostPopularProtests({
    required int n,
  }) async {
    return getNProtests(
        n: n, parameter: 'participants_amount', isDescending: true);
  }

  static Future<Protest> getProtestById({
    required String protestId,
  }) async {
    final docSnap = await protestsCollectionRef.doc(protestId).get();

    Protest? protest = docSnap.data(); // Convert to Protest object
    if (protest == null) {
      throw ProtestNotFound();
    }
    return protest;
  }

  //UP to 10 tags!!
  Future<List<Protest>> get10ProtestsByTags(
      {required n, required List<String> tagsList}) async {
    int numOfElements = min(10, tagsList.length);

    List<Protest> protestList = [];

    Iterable<String> tagsListCopy = tagsList.take(numOfElements);

    var query =
        protestsCollectionRef.orderBy('creation_time', descending: true);

    //filtering for every tag
    for (String tag in tagsListCopy) {
      query = query.where('tags', arrayContains: tag);
    }

    //get 10 that match
    var matchDocs = await query.limit(10).get();

    for (var element in matchDocs.docs) {
      protestList.add(element.data());
    }
    return protestList;
  }

  updateUser(User? fireUser) {
    if (fireUser != null) {
      syncUser(fireUser);
    }
  }

  Query<Protest> getMostRecentQuery() {
    return protestsCollectionRef.orderBy('creation_time', descending: true);
  }

  Query<Protest> getMostPopularQuery() {
    return protestsCollectionRef.orderBy('participants_amount',
        descending: true);
  }

  Query<Protest> getMyProtests() {
    return protestsCollectionRef
        .orderBy('creation_time', descending: true)
        .where('creator', isEqualTo: user.id);
  }

  Future<List<Protest>> processQuery(Query<Protest> query) async {
    List<Protest> protestList = [];
    var data = await query.get();

    for (var element in data.docs) {
      protestList.add(element.data());
    }

    return protestList;
  }

  Future<PUser> getUserById({
    required String userId,
  }) async {
    var data = await usersCollectionRef.doc(userId).get();
    return data.data()!;
  }

  Future<void> syncUser(User fireUser) async {
    user = PUser.fromFireAuth(fireUser);
    await usersCollectionRef.doc(user.id).set(user, SetOptions(merge: true));
  }

  Future<void> joinToProtest(
      String protestId, ProtestHolder protestHolder) async {
    //check if already attending
    if (await isAlreadyAttending(protestId)) {
      return;
    }

    Protest updatedProtest = protestHolder.protest;
    updatedProtest.participantsAmount += 1;
    protestHolder.protest = updatedProtest;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      //updating the protest info
      transaction.update(protestsCollectionRef.doc(protestId),
          {'participants_amount': FieldValue.increment(1)});

      //updating the attending collection
      var docRef = attendingCollectionRef.doc();
      Attender newAttender = Attender(
          docId: docRef.id,
          userID: user.id,
          protestID: protestId,
          creationTime: Timestamp.now(),
          username: user.username,
          protestName: protestHolder.protest.name);
      transaction.set(docRef, newAttender);
    });
  }

  Future<DocumentReference<Attender>?> _attendingDoc(String protestId) async {
    var matchDocs = await attendingCollectionRef
        .where('user_id', isEqualTo: user.id)
        .where('protest_id', isEqualTo: protestId)
        .limit(1)
        .get();
    if (matchDocs.docs.isEmpty) {
      return null;
    }
    return matchDocs.docs.first.reference;
  }

  Future<bool> isAlreadyAttending(String protestId) async {
    return await _attendingDoc(protestId) != null;
  }

  Future<void> leaveProtest(
      String protestId, ProtestHolder protestHolder) async {
    var attendingDocRef = await _attendingDoc(protestId);
    //check if not attending
    if (attendingDocRef == null) {
      return;
    }

    Protest updatedProtest = protestHolder.protest;
    updatedProtest.participantsAmount -= 1;
    protestHolder.protest = updatedProtest;

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      //checking the attending collection
      var attendingDoc = await transaction.get(attendingDocRef);
      if (!attendingDoc.exists) {
        return;
      }

      //updating the protest info
      transaction.update(protestsCollectionRef.doc(protestId),
          {'participants_amount': FieldValue.increment(-1)});
      transaction.delete(attendingDocRef);
    });
  }

  Future<void> addExternalLink(ProtestHolder holder, String link) async {
    var protest = holder.protest;
    protest.links.add(link);
    holder.protest = protest;
    await protestsCollectionRef
        .doc(protest.id)
        .update({'external_urls': protest.links});
  }

  Future<void> removeExternalLink(ProtestHolder holder, String link) async {
    var protest = holder.protest;
    protest.links.remove(link);
    holder.protest = protest;
    await protestsCollectionRef
        .doc(protest.id)
        .update({'external_urls': protest.links});
  }

  Query<Attender> getMyAttendings() {
    return attendingCollectionRef
        .orderBy('creation_time', descending: true)
        .where('user_id', isEqualTo: user.id);
  }

  Future<void> addStory(Protest protestToAddTo, String content) async {
    //assuming it not empty content

    var protestRef = protestsCollectionRef.doc(protestToAddTo.id);

    // TODO:  check if the protest exists

    var storyNewDocRef = protestRef
        .collection("stories")
        .withConverter(
          fromFirestore: Story.fromFirestore,
          toFirestore: (Story story, _) => story.toFirestore(),
        )
        .doc();

    Story newStory = Story(
      numOfLikes: 0,
      docId: storyNewDocRef.id,
      userID: user.id,
      content: content,
      creationTime: Timestamp.now(),
    );
    await storyNewDocRef.set(newStory);
  }

  Query<Story> queryStoriesOfProtest({required String protestId}) {
    var protestRef = protestsCollectionRef.doc(protestId);

    // TODO:  check if the protest exists and that the sub collection exists, and is convertor needed??
    return protestRef
        .collection("stories")
        .withConverter(
          fromFirestore: Story.fromFirestore,
          toFirestore: (Story story, _) => story.toFirestore(),
        )
        .orderBy("creation_time", descending: true);
  }

  Future<void> deleteStory(String protestId, Story storyToDelete) async {
    protestsCollectionRef
        .doc(protestId)
        .collection('stories')
        .doc(storyToDelete.docId)
        .delete();
  }

  Future<void> likeStory(
      String userId, String protestId, Story storyToLike) async {
    var storyRef = protestsCollectionRef
        .doc(protestId)
        .collection('stories')
        .doc(storyToLike.docId);
    var likedCollection = storyRef.collection('likes');
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      var doc = await transaction.get(likedCollection.doc(userId));
      if (doc.exists) {
        transaction.delete(likedCollection.doc(userId));
        transaction
            .update(storyRef, {'num_of_likes': FieldValue.increment(-1)});
        return;
      }
      transaction.set(likedCollection.doc(userId), {'userId': userId});
      transaction.update(storyRef, {'num_of_likes': FieldValue.increment(1)});
    });
  }

  Future<bool> isLiked(
      String userId, String protestId, Story storyToLike) async {
    var likedCollection = protestsCollectionRef
        .doc(protestId)
        .collection('stories')
        .doc(storyToLike.docId)
        .collection('likes');
    var doc = await likedCollection.doc(userId).get();
    if (doc.exists) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<void> addUpdate(Protest protestToAddTo, String content) async {
    //assuming it not empty content

    var protestRef = protestsCollectionRef.doc(protestToAddTo.id);

    // TODO:  check if the protest exists

    var updatesNewDocRef = protestRef
        .collection("updates")
        .withConverter(
          fromFirestore: Update.fromFirestore,
          toFirestore: (Update up, _) => up.toFirestore(),
        )
        .doc();

    Update newUpdate = Update(
      docId: updatesNewDocRef.id,
      userID: user.id,
      content: content,
      creationTime: Timestamp.now(),
    );
    await updatesNewDocRef.set(newUpdate);
  }

  Query<Update> queryUpdatesOfProtest({required String protestId}) {
    var protestRef = protestsCollectionRef.doc(protestId);

    // TODO:  check if the protest exists and that the sub collection exists, and is convertor needed??
    return protestRef
        .collection("updates")
        .withConverter(
          fromFirestore: Update.fromFirestore,
          toFirestore: (Update up, _) => up.toFirestore(),
        )
        .orderBy("creation_time", descending: true);
  }

// Future<void> unLikeStory(String userId, String protestId, Story storyToUnLike) async {
//   var likedCollection = protestsCollectionRef.doc(protestId).collection('stories').doc(storyToUnLike.docId).collection('likes');
//   var doc = await likedCollection.doc(userId).get();
//   if (doc.exists) {
//     likedCollection.doc(userId).delete();
//     return;
//   }
// }
//
// Future<bool> checkIfLiked(String userId, String protestId, Story storyToUnLike) async {
//   return Future.value(true);
// }

}
