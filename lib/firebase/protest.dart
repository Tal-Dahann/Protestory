import 'package:cloud_firestore/cloud_firestore.dart';

class Protest {
  String id;
  final String name;
  final Timestamp date;
  final String creator;
  final Timestamp creationTime;
  final int participantsAmount;
  final String contactInfo;
  final String description;
  final String location;
  final List<String> tags;

  Protest(
      {required this.id,
      required this.name,
      required this.date,
      required this.creator,
      required this.creationTime,
      required this.participantsAmount,
      required this.contactInfo,
      required this.description,
      required this.location,
      required this.tags});

  factory Protest.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      // TODO transform to exception
      throw Exception("Protest doesn't exist");
    }
    //TODO check when data is null
    return Protest(
      id: snapshot.id,
      name: data['name'],
      date: data['date'],
      creator: data['creator'],
      creationTime: data['creation_time'],
      participantsAmount: data['participants_amount'],
      contactInfo: data['contact_info'],
      description: data['description'],
      location: data['location'],
      tags: List.from(data['tags']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "date": date,
      "creator": creator,
      "creation_time": creationTime,
      "participants_amount": participantsAmount,
      "contact_info": contactInfo,
      "description": description,
      "location": location,
      "tags": tags,
    };
  }

  String dateAndTime() {
    DateTime dateTime = this.date.toDate();
    return "${dateTime.day.toString()}" +
        "/" +
        "${dateTime.month.toString()}" +
        "/" +
        "${dateTime.year.toString()}" +
        " , " +
        "${dateTime.hour.toString()}" +
        ":" +
        "${dateTime.minute.toString()}";
  }
}
