import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/CreateAccountPage.dart';
import 'package:postme_app/pages/navigation/NavigationBar.dart';
import 'package:postme_app/pages/login/LoginPage.dart';
import 'package:tiengviet/tiengviet.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final userReference = Firestore.instance.collection("users");
final StorageReference storageReference = FirebaseStorage.instance.ref().child("Images of posts");
final postReference = Firestore.instance.collection("posts");
final activityFeedReference = Firestore.instance.collection("feed");
final commentsReference = Firestore.instance.collection("comments");
final followersReference = Firestore.instance.collection("followers");
final followingReference = Firestore.instance.collection("following");
final timelineReference = Firestore.instance.collection("timeline");

final DateTime timestamp = DateTime.now();
User currentUser;
bool isSignedIn = false;

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  void initState() {
    super.initState();
    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError) {
        print("Error Message " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
        print("Error Message " + gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveUserInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });
    }
    else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveUserInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot = await userReference.document(gCurrentUser.id).get();

    if (!documentSnapshot.exists) {

      userReference.document(gCurrentUser.id).setData({
        "id": gCurrentUser.id,
        "profileName": gCurrentUser.displayName,
        "username": TiengViet.parse(gCurrentUser.displayName).replaceAll(' ', '').toLowerCase(),
        "url": gCurrentUser.photoUrl,
        "email": gCurrentUser.email,
        "bio": "I love Favoury!",
        "timestamp": timestamp
      });

      final username = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateAccountPage()));

      userReference.document(gCurrentUser.id).updateData({
        "username": username
      });
      documentSnapshot = await userReference.document(gCurrentUser.id).get();
      currentUser = User.fromDocument(documentSnapshot);
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  loginUser() {
    gSignIn.signIn();
  }

  logoutUser() {
    gSignIn.signOut();
  }

  void dispose() {
    super.dispose();
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: NavigationBar()
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: LoginPage()
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    }
    else {
      return buildSignInScreen();
    }
  }
}
