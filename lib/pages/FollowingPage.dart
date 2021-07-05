import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/ProfilePage.dart';
import 'package:postme_app/widgets/HeaderWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';

class FollowingPage extends StatefulWidget {
  final String userProfileId;
  final String userUsrName;
  final String userProfileImg;

  FollowingPage({this.userProfileId, this.userUsrName, this.userProfileImg});

  @override
  _FollowingPageState createState() => _FollowingPageState(userProfileId: userProfileId, userUsrName: userUsrName, userProfileImg: userProfileImg);
}

class _FollowingPageState extends State<FollowingPage> {
  final String userProfileId;
  final String userUsrName;
  final String userProfileImg;

  _FollowingPageState({this.userProfileId, this.userUsrName, this.userProfileImg});

  retrieveFollowing() {
    return StreamBuilder(
      stream: followingReference.document(userProfileId).collection("userFollowing").snapshots(),
      builder: (context, dataSnapshot) {
        if(dataSnapshot.data == null)
          return circularProgress();
        List<Following> following = [];
        dataSnapshot.data.documents.forEach((document) {
          following.add(Following.fromDocument(document));
        });
        return ListView(
            children: following
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Following"),
      body: retrieveFollowing()
    );
  }
}

class Following extends StatelessWidget {
  final String userProfileId;
  final String userUsrname;
  final String userProfileImg;

  Following({this.userProfileId, this.userUsrname, this.userProfileImg});

  factory Following.fromDocument(DocumentSnapshot documentSnapshot) {
    return Following(
        userProfileId: documentSnapshot["userProfileId"],
        userUsrname: documentSnapshot["username"],
        userProfileImg: documentSnapshot["userProfileImg"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
                onTap: () => displayUserProfile(context, userProfileId: userProfileId, userUsrName: userUsrname, userProfileImg: userProfileImg),
                title: RichText(
                  text: TextSpan(
                    text: "$userUsrname",
                    style: TextStyle(fontSize: 16.0, color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold')
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(userProfileImg),
                ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserProfile(BuildContext context, {String userProfileId, String userUsrName, String userProfileName, String userProfileImg}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userProfileId, userUsrName: userUsrName, userProfileImg: userProfileImg)));
  }
}


