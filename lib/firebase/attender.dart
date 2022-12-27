import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/exceptions.dart';

class Attender {
  String docId;
  final String userID;
  final String username;
  final String protestID;
  final String protestName;
  final Timestamp creationTime;

  Attender({
    required this.docId,
    required this.userID,
    required this.protestID,
    required this.creationTime,
    required this.username,
    required this.protestName,
  });

  factory Attender.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw AttenderNotFound();
    }
    return Attender(
        docId: snapshot.id,
        userID: data['user_id'],
        protestID: data['protest_id'],
        creationTime: data['creation_time'],
        username: data['username'],
        protestName: data['protest_name']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userID,
      'protest_id': protestID,
      'creation_time': creationTime,
      'username': username,
      'protest_name': protestName
    };
  }
}
