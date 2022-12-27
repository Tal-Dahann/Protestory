import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protestory/constants/colors.dart';
import 'package:protestory/utils/exceptions.dart';
import 'package:protestory/widgets/loading.dart';

class PUser {
  final String id;
  final String username;
  final String? photoURL;

  PUser({required this.id, required this.username, this.photoURL});

  PUser.fromFireAuth(User fireUser)
      : id = fireUser.uid,
        username = fireUser.displayName ?? 'Anonymous',
        photoURL = fireUser.photoURL;

  static Widget getAvatarLoadingWidget({double? radius}) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      child: const LoadingWidget(),
    );
  }

  Widget getAvatarWidget({double? radius}) {
    if (photoURL == null) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: blue,
        child: Icon(
          Icons.person,
          color: white,
          size: radius,
        ),
      );
    }
    var avatarLoadingCompleter = Completer<NetworkImage>();
    var image = NetworkImage(photoURL!);
    image
        .resolve(ImageConfiguration.empty)
        .addListener(ImageStreamListener((info, call) {
      avatarLoadingCompleter.complete(image);
    }));
    return FutureBuilder<NetworkImage>(
      future: avatarLoadingCompleter.future,
      builder: (builder, snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: radius,
            backgroundImage: snapshot.requireData,
          );
        }
        return getAvatarLoadingWidget(radius: radius);
      },
    );
  }

  factory PUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw UserNotFound();
    }
    return PUser(
        id: snapshot.id,
        username: data['username'],
        photoURL: data['photo_url']);
  }

  Map<String, dynamic> toFirestore() {
    return {'username': username, if (photoURL != null) 'photo_url': photoURL};
  }
}
