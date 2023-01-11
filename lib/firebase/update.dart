import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/exceptions.dart';

class Update {
  String docId;
  final String userID;
  final String content;
  final Timestamp creationTime;

  Update({
    required this.docId,
    required this.userID,
    required this.content,
    required this.creationTime,
  });

  factory Update.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw UpdateNotFound();
    }
    return Update(
      docId: snapshot.id,
      userID: data['user_id'],
      content: data['content'],
      creationTime: data['creation_time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'user_id': userID,
      'content': content,
      'creation_time': creationTime,
    };
  }
}
