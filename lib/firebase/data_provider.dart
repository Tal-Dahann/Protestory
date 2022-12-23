import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:protestory/firebase/protest.dart';

class DataProvider {
  static const version = "1.0.0";
  static final firestore =
      FirebaseFirestore.instance.collection("versions").doc("v$version");
  static final firestorage = FirebaseStorage.instance.ref("v$version");

  late final CollectionReference<Protest> protestCollectionRef;

  User user;

  DataProvider({required this.user}) {
    protestCollectionRef = firestore.collection("protests").withConverter(
          fromFirestore: Protest.fromFirestore,
          toFirestore: (Protest protest, _) => protest.toFirestore(),
        );
  }

  CollectionReference<Protest> get getProtestCollectionRef =>
      protestCollectionRef;

  Future<Protest> addProtest(
      {required String name,
      required DateTime date,
      required String contactInfo,
      required String description,
      required String location,
      required List<String> tags,
      required File image}) async {
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
      tags: tags,
    );
    await firestorage.child('protests_images').child(docRef.id).putFile(image);
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

  Query<Protest> getMostRecentQuery() {
    return protestCollectionRef.orderBy('creation_time', descending: true);
  }

  Query<Protest> getMostPopularQuery() {
    return protestCollectionRef.orderBy('participants_amount',
        descending: true);
  }

  Query<Protest> getMyProtests() {
    return protestCollectionRef
        .orderBy('creation_time', descending: true)
        .where('creator', isEqualTo: user.uid);
  }

  Future<List<Protest>> processQuery(Query<Protest> query) async {
    List<Protest> protestList = [];
    var data = await query.get();

    for (var element in data.docs) {
      protestList.add(element.data());
    }

    return protestList;
  }
}
