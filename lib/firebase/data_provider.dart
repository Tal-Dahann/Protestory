import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:protestory/firebase/protest.dart';

class DataProvider {
  static const version = "1.0.0";
  final _firestore =
      FirebaseFirestore.instance.collection("versions").doc("v$version");

  late final CollectionReference<Protest> protestCollectionRef;

  User user;

  DataProvider({required this.user}) {
    protestCollectionRef = _firestore.collection("protests").withConverter(
          fromFirestore: Protest.fromFirestore,
          toFirestore: (Protest protest, _) => protest.toFirestore(),
        );
  }

  Future<Protest> addProtest(
      {required String name,
      required DateTime date,
      required String contactInfo,
      required String description,
      required String location,
      required List<String> tags}) async {
    //creating doc to the protest
    var docRef = protestCollectionRef.doc();
    Protest newProtest = Protest(
        id: docRef.id,
        name: name,
        date: Timestamp.fromDate(date),
        creator: user.uid,
        creationTime: Timestamp.fromDate(DateTime.now()),
        participantsAmount: 0,
        contactInfo: contactInfo,
        description: description,
        location: location,
        tags: tags);
    await docRef.set(newProtest);

    return newProtest;
  }

  //parameter is the name of the field we sorting by
  Future<List<Protest>> getNProtests(
      {required n,
      required String parameter,
      required bool isDescending}) async {
    List<Protest> protestList = [];
    // print("entered getNprotests" + "\n");
    var query = await protestCollectionRef
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
    required n,
  }) async {
    return getNProtests(n: n, parameter: "creation_time", isDescending: true);
  }

  Future<List<Protest>> getMostPopularProtests({
    required n,
  }) async {
    return getNProtests(
        n: n, parameter: "participants_amount", isDescending: true);
  }

  //TODO: exception handling
  Future<Protest> getProtestById({
    required String protestId,
  }) async {
    final docSnap = await protestCollectionRef.doc(protestId).get();

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

    var query = protestCollectionRef.orderBy("creation_time", descending: true);

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

  updateUser(User? user) {
    this.user = user ?? this.user;
  }
}
