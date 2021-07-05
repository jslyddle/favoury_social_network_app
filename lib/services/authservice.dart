import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postme_app/models/user.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:postme_app/pages/login/SignInPage.dart';
import 'package:postme_app/pages/login/SignUpPage.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/services/error_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//import '../home_page.dart';

class AuthService {
  //Determine if the user is authenticated.
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else
            return SignInPage();
        });
  }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //Sign In
  signIn(String email, String password, context) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
  }
  //Signup a new user
  signUp(String email, String password, String profile) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  }

  //Reset Password
  resetPasswordLink(String email) {
    FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }
}