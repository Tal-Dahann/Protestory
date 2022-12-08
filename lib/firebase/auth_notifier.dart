import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthStatus { authenticated, unauthenticated, authenticating }

class AuthNotifier extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  var _status = AuthStatus.unauthenticated;
  User? _user;

  bool _disposed = false;

  AuthNotifier() {
    _auth.authStateChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = firebaseUser;
        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  AuthStatus get status => _status;

  User? get user => _user;

  bool isAuthenticated() {
    return status == AuthStatus.authenticated;
  }

  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **user-disabled**:
  ///  - Thrown if the user corresponding to the given email has been disabled.
  /// - **user-not-found**:
  ///  - Thrown if there is no user corresponding to the given email.
  /// - **wrong-password**:
  ///  - Thrown if the password is invalid for the given email, or the account
  ///    corresponding to the email does not have a password set.
  Future<bool> login(String email, String password) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  /// A [FirebaseAuthException] maybe thrown with the following error code:
  /// - **email-already-in-use**:
  ///  - Thrown if there already exists an account with the given email address.
  /// - **invalid-email**:
  ///  - Thrown if the email address is not valid.
  /// - **weak-password**:
  ///  - Thrown if the password is not strong enough.
  Future<UserCredential> signUp(
      String email, String password, String username) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      return userCredential;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
