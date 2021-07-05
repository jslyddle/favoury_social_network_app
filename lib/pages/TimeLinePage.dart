import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/widgets/HeaderWidget.dart';
import 'package:postme_app/widgets/PostWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';


class TimeLinePage extends StatefulWidget {

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts = [];
  List<String> followingList = [];

  retrieveTimeLine() async {
    setState(() {
      followingList.clear();
      posts.clear();
    });

    followingList.insert(0, currentUser.id);

    QuerySnapshot querySnapshot1 = await followingReference.document(currentUser.id).collection("userFollowing").getDocuments();
    List<DocumentSnapshot> documents = querySnapshot1.documents;
    setState(() {
      documents.forEach((snapshot) {
        followingList.add(snapshot.documentID);
      });
    });

    for (int i = 0; i < followingList.length; i++) {
      if (postReference.document(followingList.elementAt(i)) != null) {
        QuerySnapshot querySnapshot2 = await postReference.document(followingList.elementAt(i)).collection("usersPosts").getDocuments();
        querySnapshot2.documents.forEach((document) {
          timelineReference.document("timeline").collection("timeLinePosts").add(document.data);
        });
      }
    }

    QuerySnapshot querySnapshot3 = await timelineReference.document("timeline").collection("timeLinePosts").orderBy("timestamp", descending: true).getDocuments();
    setState(() {
      //List<Post> allPosts;
      posts = querySnapshot3.documents.map((document) => Post.fromDocument(document)).toList();
      //posts += allPosts;
      querySnapshot3.documents.forEach((document) {
        document.reference.delete();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    retrieveTimeLine();
  }

  Container displayNoPostsScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
            children: [
              SizedBox(height: 245),
              Image.asset('assets/images/login_logo.png', scale: 1),
              SizedBox(height: 15),
              Container(
                  child: Text(
                      "Let's follow someone or" + "\nshare your Favours",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold', fontSize: 23.0)
                  )
              ),
            ]
        )
    );
  }

  createUserTimeLine() {
    if (posts.isEmpty) {
      return displayNoPostsScreen();
    }
    else {
      return ListView(
          children: posts
      );
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true, disappearBackButton: true),
      body: RefreshIndicator(child: createUserTimeLine(), onRefresh: () => retrieveTimeLine()),
    );
  }
}
