import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'data_provider.dart';

class Protest {
  static final dateFormatter = DateFormat('dd/MM/yyyy kk:mm');

  String id;
  final String name;
  String lowerCaseName;
  final Timestamp date;
  final String creator;
  final Timestamp creationTime;
  final int participantsAmount;
  final String contactInfo;
  final String description;
  final String location;
  final List<String> tags;
  late final Future<NetworkImage> image;
  final bool includeImage;

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
      required this.tags,
      this.includeImage = true})
      : lowerCaseName = name.toLowerCase() {
    if (includeImage) loadImage();
  }

  loadImage() {
    image = _loadImage();
  }

  Future<NetworkImage> _loadImage() async {
    Completer<NetworkImage> completer = Completer<NetworkImage>();
    NetworkImage avatar = NetworkImage(await DataProvider.firestorage
        .child('protests_images')
        .child(id)
        .getDownloadURL());
    avatar.resolve(ImageConfiguration.empty).addListener(
        ImageStreamListener((info, call) => completer.complete(avatar)));
    return completer.future;
  }

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
    List<String> pl = getAllPrefixes();
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
      "lower_case_name": lowerCaseName,
      "prefixes_name": pl,
    };
  }

  String dateAndTime() {
    return dateFormatter.format(date.toDate());
  }

  List<String> getAllPrefixes() {
    List<String> pl = [];
    int length = lowerCaseName.length;
    for (int i = 0; i <= length; i++) {
      pl.add(lowerCaseName.substring(0, i));
    }
    return pl;
  }
}
