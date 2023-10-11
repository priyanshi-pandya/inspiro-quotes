import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:inspiro_quotes/screens/authentication/login.dart';
import 'package:inspiro_quotes/screens/authentication/login.dart';
import 'package:inspiro_quotes/utils/shared_pref/shared_pref.dart';

class AuthService {
  static GoogleSignIn _googleSignIn = GoogleSignIn();
  static User? user;
  static Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? _googleSignInAccount =
          await _googleSignIn.signIn();
        SharedPref.setUserDetails(email: _googleSignInAccount!.email, name: _googleSignInAccount.displayName,);
      final GoogleSignInAuthentication _googleSignInAuthentication =
          await _googleSignInAccount!.authentication;

      final AuthCredential _credential = GoogleAuthProvider.credential(
        accessToken: _googleSignInAuthentication.accessToken,
        idToken: _googleSignInAuthentication.idToken,
      );

      UserCredential _userCredential =
          await FirebaseAuth.instance.signInWithCredential(_credential);

      user = _userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message.toString(),
          ),
        ),
      );
    }
  }

  static Future<User?> signInWithFB(BuildContext context) async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential fbCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await FirebaseAuth.instance.signInWithCredential(fbCredential);
          return userCredential.user;
        case LoginStatus.cancelled:
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login Cancelled by User")));
        case LoginStatus.failed:
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login failed")));
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message.toString())));
    }
  }

  static Future<void> googleSignOut() async {
    await _googleSignIn.signOut();
  }
  static Future<void> fbSignOut() async {
    await FacebookAuth.instance.logOut();
  }
}
