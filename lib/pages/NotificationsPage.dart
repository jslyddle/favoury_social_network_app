import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/PostScreenPage.dart';
import 'package:postme_app/widgets/HeaderWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';
import 'ProfilePage.dart';
import 'package:timeago/timeago.dart' as tAgo;

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationsItem> notificationsItem = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Notifications", disappearBackButton: true),
      body: RefreshIndicator(
        child: createUserNotifications(),
        onRefresh: () => retrieveNotifications(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    retrieveNotifications();
  }

  Container displayNoNotisScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
            children: [
              SizedBox(height: 245),
              Image.asset('assets/images/no_notis_image.png', scale: 5),
              SizedBox(height: 15),
              Container(
                  child: Text(
                      "You won't miss" + "\n anything!",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold', fontSize: 23.0)
                  )
              ),
            ]
        )
    );
  }

  createUserNotifications() {
    if (notificationsItem.isEmpty) {
      return displayNoNotisScreen();
    }
    else {
      return ListView(
          children: notificationsItem
      );
    }
  }

  retrieveNotifications() async {

    QuerySnapshot querySnapshot = await activityFeedReference.document(currentUser.id)
        .collection("feedItems")
        .orderBy("timestamp", descending: true).limit(60)
        .getDocuments();

    setState(() {
      notificationsItem = querySnapshot.documents.map((document) => NotificationsItem.fromDocument(document)).toList();
    });
  }
}

String notificationItemText;
Widget mediaPreview;

class NotificationsItem extends StatelessWidget {
  final String username;
  final String type;
  final String commentData;
  final String postId;
  final String userId;
  final String userProfileImg;
  final String url;
  final Timestamp timestamp;

  NotificationsItem({this.username, this.type, this.commentData, this.postId, this.userId, this.userProfileImg, this.url, this.timestamp});

  factory NotificationsItem.fromDocument(DocumentSnapshot documentSnapshot) {
    return NotificationsItem(
      username: documentSnapshot["username"],
      type: documentSnapshot["type"],
      commentData: documentSnapshot["commentData"],
      postId: documentSnapshot["postId"],
      userId: documentSnapshot["userId"],
      userProfileImg: documentSnapshot["userProfileImg"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {

    configureMediaPreview(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 7.0),
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            ListTile(
                onTap: () => displayUserProfile(context, userProfileId: userId, userUsrName: username, userProfileImg: userProfileImg),
                title: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: username,
                        style: TextStyle(fontSize: 16.0, color: Color(0xFF05268D),fontFamily: 'MontserratSemiBold'),
                      ),
                      TextSpan(
                        text: " $notificationItemText",
                        style: TextStyle(fontSize: 16.0, color: Color(0xFF05268D), fontFamily: 'MontserratMedium'),
                      ),
                    ],
                  ),
                ),
                leading: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(userProfileImg),
                ),
                subtitle: Text(tAgo.format(timestamp.toDate()), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 13.3, color: Color(0xFF5F7ED9), fontFamily: 'MontserratRegular')),
                trailing: mediaPreview
            ),
          ],
        ),
      ),
    );
  }

  configureMediaPreview(context) {
    if (type == "comment" || type == "like") {
      mediaPreview = GestureDetector(
        onTap: () => displayPost(context),
        child: Container(
          height: 48.0,
          width: 48.0,
          child: AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(fit: BoxFit.cover, image: CachedNetworkImageProvider(url))
              ),
            ),
          ),
        ),
      );
    }
    else {
      mediaPreview = Text("");
    }

    if (type == "like") {
      notificationItemText = "liked your Favour.";
    }
    else if (type == "comment") {
      notificationItemText = "commented: $commentData.";
    }
    else if (type == "follow") {
      notificationItemText = "started following you.";
    }
    else {
      notificationItemText = "Error: unknown type.";
    }
  }

  displayPost(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreenPage(postId: postId, userId: currentUser.id)));
  }

  displayUserProfile(BuildContext context, {String userProfileId, String userUsrName, String userProfileName, String userProfileImg}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userProfileId, userUsrName: userUsrName, userProfileImg: userProfileImg)));
  }
}