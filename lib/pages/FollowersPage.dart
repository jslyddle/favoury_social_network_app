import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/ProfilePage.dart';
import 'package:postme_app/widgets/HeaderWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';

class FollowersPage extends StatefulWidget {
  final String userProfileId;
  final String userUsrName;
  final String userProfileImg;

  FollowersPage({this.userProfileId, this.userUsrName, this.userProfileImg});

  @override
  _FollowersPageState createState() => _FollowersPageState(userProfileId: userProfileId, userUsrName: userUsrName, userProfileImg: userProfileImg);
}

class _FollowersPageState extends State<FollowersPage> {
  final String userProfileId;
  final String userUsrName;
  final String userProfileImg;

  _FollowersPageState({this.userProfileId, this.userUsrName, this.userProfileImg});

  retrieveFollowers() {
    return StreamBuilder(
      stream: followersReference.document(userProfileId).collection("userFollowers").snapshots(),
      builder: (context, dataSnapshot) {
        if(dataSnapshot.data == null)
          return circularProgress();
        List<Followers> followers = [];
        dataSnapshot.data.documents.forEach((document){
          followers.add(Followers.fromDocument(document));
        });
        return ListView(
            children: followers
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(context, strTitle: "Followers"),
        body: retrieveFollowers()
    );
  }
}

class Followers extends StatelessWidget {
  final String userProfileId;
  final String userUsrname;
  final String userProfileImg;

  Followers({this.userProfileId, this.userUsrname, this.userProfileImg});

  factory Followers.fromDocument(DocumentSnapshot documentSnapshot) {
    return Followers(
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


