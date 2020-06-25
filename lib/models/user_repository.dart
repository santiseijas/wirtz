import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wirtz/models/user.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final databaseReference = Firestore.instance;

  UserRepository({FirebaseAuth firebaseAuth, GoogleSignIn googleSignin})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _googleSignIn = googleSignin ?? GoogleSignIn();

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    return _firebaseAuth.currentUser();
  }

  Future<void> signInWithCredentials(String email, String password) {
    // getUserId();
    //setFireBaseIdDocument();
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signUp(
      {String email, String password, String nombre, String uid}) async {
    //setFireBaseIdDocument();

     await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
     setFireBaseIdDocument(nombre);
  }

  Future<void> signOut() async {
    return Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    return currentUser != null;
  }

  Future<String> getUser() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

//recuperamos el id del current user y guardamos en firebase un nuevo documento con el mismo id
  void setFireBaseIdDocument(String nombre) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    final FirebaseUser user = await _auth.currentUser();
    final uid = user.uid;
    await databaseReference
        .collection("users")
        .document(uid)
        .setData({'email': user.email, 'uid': user.uid,'nombre':nombre});
  }


}
