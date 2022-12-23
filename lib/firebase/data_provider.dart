import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter_platform_interface/src/types/location.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/firebase/user.dart';

class DataProvider {
  static const version = "1.0.0";
  static final firestore =
      FirebaseFirestore.instance.collection("versions").doc("v$version");
  static final firestorage = FirebaseStorage.instance.ref("v$version");

  late final CollectionReference<Protest> protestsCollectionRef;
  late final CollectionReference<PUser> usersCollectionRef;

  late PUser user;

  DataProvider(User fireUser) {
    protestsCollectionRef = firestore.collection("protests").withConverter(
          fromFirestore: Protest.fromFirestore,
          toFirestore: (Protest protest, _) => protest.toFirestore(),
        );
    usersCollectionRef = firestore.collection("users").withConverter(
        fromFirestore: PUser.fromFirestore,
        toFirestore: (PUser user, _) => user.toFirestore());
    syncUser(fireUser);
  }

  CollectionReference<Protest> get getProtestCollectionRef =>
      protestsCollectionRef;

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
      location: location,
      locationLatLng: locationLatLng,
      tags: tags,
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
      location: location,
      locationLatLng: locationLatLng,
      tags: tags,
    );
    if (image != null) {
      //if its null, we didnt update the image so we dont need to update firestorage
      await firestorage
          .child('protests_images')
          .child(protest.id)
          .putFile(image);
    }
    await docRef.set(updatedProtest);
    return updatedProtest;
  }

  Future<void> deleteProtest(Protest protestToDelete) async {
    firestorage.child('protests_images').child(protestToDelete.id).delete();
    return await protestsCollectionRef.doc(protestToDelete.id).delete();
  }

  //parameter is the name of the field we sorting by
  Future<List<Protest>> getNProtests(
      {required n,
      required String parameter,
      required bool isDescending}) async {
    List<Protest> protestList = [];
    // print("entered getNprotests" + "\n");
    var query = await protestsCollectionRef
        .orderBy(parameter, descending: isDescending)
        .limit(n)
        .get();

    for (var element in query.docs) {
      protestList.add(element.data());
      // print("added protest :" + "${element.data().name}" + "\n");
    }

    return protestList;
  }

  Future<List<Protest>> getMostRecentProtests({
    required int n,
  }) async {
    return getNProtests(n: n, parameter: "creation_time", isDescending: true);
  }

  Future<List<Protest>> getMostPopularProtests({
    required int n,
  }) async {
    return getNProtests(
        n: n, parameter: "participants_amount", isDescending: true);
  }

  //TODO: exception handling
  Future<Protest> getProtestById({
    required String protestId,
  }) async {
    final docSnap = await protestsCollectionRef.doc(protestId).get();

    Protest? protest = docSnap.data(); // Convert to Protest object
    if (protest != null) {
      return protest;
    } else {
      throw Exception('getProtestById error- no protest with the requested id');
    }
  }

  // Future<Protest> getNextProtestByIndex({
  //   required int startIndex,
  //   required CollectionReference<Protest> collectionRF
  // }) async {
  //
  // }

  //UP to 10 tags!!
  Future<List<Protest>> get10ProtestsByTags(
      {required n, required List<String> tagsList}) async {
    int numOfElements = min(10, tagsList.length);

    List<Protest> protestList = [];

    Iterable<String> tagsListCopy = tagsList.take(numOfElements);

    var query =
        protestsCollectionRef.orderBy("creation_time", descending: true);

    //filtering for every tag
    for (String tag in tagsListCopy) {
      query = query.where("tags", arrayContains: tag);
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
}
