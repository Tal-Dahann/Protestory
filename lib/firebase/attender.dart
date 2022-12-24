import 'package:cloud_firestore/cloud_firestore.dart';

class Attender {
  String docId;
  final String userID;
  final String protestID;
  final Timestamp creationTime;

  Attender(
      {required this.docId,
      required this.userID,
      required this.protestID,
      required this.creationTime});

  factory Attender.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      // TODO transform to exception
      throw Exception("Attender doesn't exist");
    }
    //TODO check when data is null
    return Attender(
      docId: snapshot.id,
      userID: data['user_id'],
      protestID: data['protest_id'],
      creationTime: data['creation_time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "user_id": userID,
      "protest_id": protestID,
      "creation_time": creationTime,
    };
  }
}
