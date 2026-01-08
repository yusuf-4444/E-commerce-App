import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<bool> loginWithEmailAndPassword(String email, String password);
  Future<bool> registerWithEmailAndPassword(String email, String password);
  Future<bool> authenticateWithGoogle();
  Future<bool> authenticateWithFacebook();
  User? getCurrentUser();
  Future<void> logout();
}

class AuthServiceImpl implements AuthService {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> loginWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  @override
  Future<bool> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user != null;
    } catch (e) {
      debugPrint('Registration error: $e');
      return false;
    }
  }

  @override
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  @override
  Future<bool> authenticateWithGoogle() async {
    final gUser = await GoogleSignIn().signIn();
    final gAuth = await gUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: gAuth?.idToken,
      accessToken: gAuth?.accessToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> authenticateWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    if (loginResult.status != LoginStatus.success) {
      return false;
    }
    final credential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    if (userCredential.user != null) {
      return true;
    } else {
      return false;
    }
  }
}
