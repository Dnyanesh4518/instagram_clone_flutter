import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone_flutter/assets/utils.dart';
import 'package:instagram_clone_flutter/models/users.dart' as model;
import 'package:instagram_clone_flutter/resources/Storage_methods.dart';

import '../models/Post.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap = await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }
  Future<String> SignUpUser(
      {
        required String email,
        required String password,
        required String username,
        required String bio,
        required Uint8List file}) async {
    String res = "Some error has occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String photoURL = await StorageMethods()
            .uploadImageToStorage('profilePictures', file, false);

        model.User user = model.User(
          username: username,
          bio: bio,
          email: email,
          uid: credential.user!.uid,
          photoURL: photoURL,
          following: [],
          followers: [],
        );
        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "Some error occured";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "please enter all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  Future<void> logoutUser() async
  {
    try
    {
      _auth.signOut();
    }
    catch(e)
    {
      print(e.toString());
    }

  }
}
