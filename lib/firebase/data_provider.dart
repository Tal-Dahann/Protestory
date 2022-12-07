import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protestory/firebase/protest.dart';
import 'package:protestory/firebase/user.dart';

class DataProvider {
  static const version = "1.0.0";
  final _firestore =
      FirebaseFirestore.instance.collection("versions").doc("v$version");

  late final CollectionReference<Protest> protestCollectionRef;

  late final CollectionReference<User> userCollectionRef;

  DataProvider() {
    protestCollectionRef = _firestore.collection("protests").withConverter(
          fromFirestore: Protest.fromFirestore,
          toFirestore: (Protest protest, _) => protest.toFirestore(),
        );

    userCollectionRef = _firestore.collection("users").withConverter(
          fromFirestore: User.fromFirestore,
          toFirestore: (User user, _) => user.toFirestore(),
        );
  }

  Future<Protest> addProtest(
      {required String name,
      required DateTime date,
      required User userCreator,
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
        creator: userCreator.id,
        creationTime: Timestamp.fromDate(DateTime.now()),
        participantsAmount: 0,
        contactInfo: contactInfo,
        description: description,
        location: location,
        tags: tags);
    await docRef.set(newProtest);

    return newProtest;
  }

  Future<User> addUser(
      {required String userId, required String username}) async {
    User newUser = User(id: userId, username: username);

    //creating new doc to the user
    await userCollectionRef.doc(userId).set(newUser);

    return newUser;
  }
}
