import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthImplementation{
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password);
  Future<String> getCurrentUserId();
  Future<void> signOut();
}

class Auth implements AuthImplementation{
  final FirebaseAuth _mAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    final AuthResult authResult = await _mAuth.signInWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = authResult.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    final AuthResult authResult = await _mAuth.createUserWithEmailAndPassword(email: email, password: password);
    final FirebaseUser user = authResult.user;
    return user.uid;
  }

  Future<String> getCurrentUserId() async {
    final FirebaseUser user = await _mAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    _mAuth.signOut();
  }
}