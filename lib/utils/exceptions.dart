import 'package:flutter/material.dart';

abstract class ProtestoryException implements Exception {
  static showExceptionSnackBar(BuildContext context,
      {String message = 'Unknown error occurred. Try later'}) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () => {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

abstract class DataProviderException extends ProtestoryException {}

class UserNotFound extends DataProviderException {}

class ProtestNotFound extends DataProviderException {}

class AttenderNotFound extends DataProviderException {}
