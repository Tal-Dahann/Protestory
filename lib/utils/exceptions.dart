import 'package:flutter/material.dart';

abstract class ProtestoryException implements Exception {
  static showExceptionSnackBar(BuildContext context,
      {String message = 'Unknown error occurred. Try later'}) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () => {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class NavigationNotInitialized extends ProtestoryException {}

abstract class DataProviderException extends ProtestoryException {}

class UserNotFound extends DataProviderException {}

class ProtestNotFound extends DataProviderException {}

class AttenderNotFound extends DataProviderException {}

class StoryNotFound extends DataProviderException {}

class UpdateNotFound extends DataProviderException {}
