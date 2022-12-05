import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;

  User({required this.id, required this.username});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      // TODO transform to exception
      throw Exception("User doesn't exist");
    }
    //TODO check when data is null
    return User(id: snapshot.id, username: data['username']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      "username": username,
    };
  }
}
