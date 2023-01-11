import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/exceptions.dart';

class Story {
  String docId;
  final String userID;
  final String content;
  final Timestamp creationTime;
  final int numOfLikes;

  Story({
    required this.numOfLikes,
    required this.docId,
    required this.userID,
    required this.content,
    required this.creationTime,
  });

  factory Story.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw StoryNotFound();
    }
    return Story(
      numOfLikes: data['num_of_likes'],
      docId: snapshot.id,
      userID: data['user_id'],
      content: data['content'],
      creationTime: data['creation_time'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'num_of_likes': numOfLikes,
      'user_id': userID,
      'content': content,
      'creation_time': creationTime,
    };
  }
}
