import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthStatus { authenticated, unauthenticated, authenticating, initiation }

class AuthProvider extends ChangeNotifier {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var _status = AuthStatus.initiation;
  User? _user;
  GoogleSignInAccount? googleUser;

  bool _disposed = false;

  AuthProvider() {
    _auth.userChanges().listen((User? firebaseUser) async {
      if (firebaseUser == null) {
        _user = null;
        status = AuthStatus.unauthenticated;
      } else {
        _user = firebaseUser;
        status = AuthStatus.authenticated;
      }
    });
  }

  AuthStatus get status => _status;

  set status(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  User? get user => _user;

  bool isAuthenticated() {
    return status == AuthStatus.authenticated;
  }

  bool isReady() {
    return status != AuthStatus.initiation;
  }

  Future<bool> signInGoogle() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      return false;
    }
    GoogleSignInAuthentication googleAuthentication =
        await googleUser.authentication;
    await _auth.signInWithCredential(GoogleAuthProvider.credential(
        accessToken: googleAuthentication.accessToken,
        idToken: googleAuthentication.idToken));
    return true;
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
  Future<void> signInEmailPassword(String email, String password) async {
    try {
      status = AuthStatus.authenticating;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      status = AuthStatus.unauthenticated;
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
      status = AuthStatus.authenticating;
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await userCredential.user?.updateDisplayName(username);
      return userCredential;
    } catch (e) {
      status = AuthStatus.unauthenticated;
      rethrow;
    }
  }

  Future<void> signOut() async {
    if (await _googleSignIn.isSignedIn()) {
      await _googleSignIn.signOut();
    }
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
