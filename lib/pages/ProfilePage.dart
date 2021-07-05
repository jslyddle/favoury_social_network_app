import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/EditProfilePage.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/FollowingPage.dart';
import 'package:postme_app/pages/FollowersPage.dart';
import 'package:postme_app/widgets/PostTileWidget.dart';
import 'package:postme_app/widgets/PostWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';
import 'package:postme_app/services/authservice.dart';
import 'login/SignUpPage.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  final String userUsrName;
  final String userProfileImg;
  ProfilePage({this.userProfileId, this.userUsrName, this.userProfileImg});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser?.id;
  bool loading = false;
  int countPosts = 0;
  List<Post> postsList = [];
  String postOrientation = "grid";
  int countTotalFollowers = 0;
  int countTotalFollowing = 0;
  bool following = false;

  void initState() {
    super.initState();
    getAllProfilePosts();
    getAllFollowers();
    getAllFollowing();
    checkIfAlreadyFollowing();
  }


  getAllFollowing() async {
    QuerySnapshot querySnapshot = await followingReference.document(widget.userProfileId)
        .collection("userFollowing")
        .getDocuments();
    setState(() {
      countTotalFollowing = querySnapshot.documents.length;
    });
  }

  checkIfAlreadyFollowing() async {
    DocumentSnapshot documentSnapshot = await followersReference
        .document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .get();
    setState(() {
      following = documentSnapshot.exists;
    });
  }

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await followersReference.document(widget.userProfileId)
        .collection("userFollowers")
        .getDocuments();
    setState(() {
      countTotalFollowers = querySnapshot.documents.length;
    });
  }

  createProfileTopView() {
    getAllFollowers();
    getAllFollowing();
    reloadProfilePosts();
    return FutureBuilder(
      future: userReference.document(widget.userProfileId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        return Padding(
          padding: EdgeInsets.all(17.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 45.0,
                    backgroundColor: Colors.grey,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            createColumn("posts", countPosts),
                            GestureDetector(
                                onTap: () => displayFollowers(context, userProfileId: widget.userProfileId, userUsrName: widget.userUsrName, userProfileImg: widget.userProfileImg),
                                child: createColumn("followers", countTotalFollowers)
                            ),
                            GestureDetector(
                                onTap: () => displayFollowing(context, userProfileId: widget.userProfileId, userUsrName: widget.userUsrName, userProfileImg: widget.userProfileImg),
                                child: createColumn("following", countTotalFollowing)
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            createButton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 13.0),
                child: Text(
                  user.profileName,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'MontserratSemiBold', color: Color(0xFF05268D)),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  user.bio,
                  style: TextStyle(fontSize: 15.0, fontFamily: 'MontserratMedium', color: Color(0xFF5F7ED9)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Column createColumn(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(fontSize: 21.0, color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold'),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
              title,
              style: TextStyle(fontSize: 10.0, color: Color(0xFF5F7ED9), fontFamily: 'MontserratMedium')
          ),
        ),
      ],
    );
  }

  createButton() {
    // Only allow to edit my profile, cannot edit other users' profiles.
    bool ownProfile = (currentOnlineUserId == widget.userProfileId);
    if (ownProfile) {
      return createButtonTitleAndFunction(title: "Edit My Favoury", performFunction: editUserProfile);
    }
    else if (following) {
      return createButtonTitleAndFunction(title: "Unfollow", performFunction: controlUnfollowUser);
    }
    else if (!following) {
      return createButtonTitleAndFunction(title: "Follow", performFunction: controlFollowUser);
    }
  }

  controlUnfollowUser() {
    setState(() {
      following = false;
    });
    followersReference.document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    followingReference.document(currentOnlineUserId)
        .collection("userFollowing")
        .document(widget.userProfileId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    activityFeedReference.document(widget.userProfileId).collection("feedItems")
        .document(currentOnlineUserId)
        .get()
        .then((document){
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  controlFollowUser() {
    setState(() {
      following = true;
    });
    followersReference.document(widget.userProfileId)
        .collection("userFollowers")
        .document(currentOnlineUserId)
        .setData({
      "userProfileId": currentOnlineUserId,
      "username": currentUser.username,
      "userProfileImg": currentUser.url
    });
    followingReference.document(currentOnlineUserId)
        .collection("userFollowing")
        .document(widget.userProfileId)
        .setData({
      "userProfileId": widget.userProfileId,
      "username": widget.userUsrName,
      "userProfileImg": widget.userProfileImg
    });
    activityFeedReference.document(widget.userProfileId)
        .collection("feedItems")
        .document(currentOnlineUserId)
        .setData({
      "type": "follow",
      "ownerId": widget.userProfileId,
      "username": currentUser.username,
      "timestamp": DateTime.now(),
      "userProfileImg": currentUser.url,
      "userId": currentOnlineUserId,
    });
  }

  createButtonTitleAndFunction({String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      // ignore: deprecated_member_use
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          width: 230.0,
          height: 32.0,
          padding: EdgeInsets.only(bottom: 2),
          child: Text(title, style: TextStyle(fontFamily: 'MontserratSemiBold', color: following ? Colors.white : Colors.white, fontWeight: FontWeight.bold)),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: following ? Color(0xFF05268D) : Color(0xff607dd9),
              borderRadius: BorderRadius.circular(27.0)
          ),
        ),
      ),
    );
  }

  editUserProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfilePage(currentOnlineUserId: currentOnlineUserId))).then((value) => setState(() {}));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text((widget.userProfileId == currentOnlineUserId) ? currentUser?.username : widget.userUsrName, style: TextStyle(fontFamily: 'MontserratBold', color: Color(0xFF05268D), fontSize: 23.0)),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.only(right: 28),
            onPressed: () => logoutUser(context),
            icon: (widget.userProfileId == currentOnlineUserId) ?  Icon(Icons.exit_to_app, color: Color(0xFF05268D), size: 30.0,) : Text(""),
          )
        ],
      ),
      body: controlDisplayProfile()
    );
  }

  controlDisplayProfile() {
    return ListView(
      children: <Widget>[
        createProfileTopView(),
        Divider(),
        createListAndGridPostOrientation(),
        Divider(height: 2.0),
        displayProfilePosts()
      ],
    );
  }


  displayProfilePosts() {
    if (loading) {
      return circularProgress();
    }
    else if (postsList.isEmpty) {
      return Container(
          child: Column(
              children: [
                SizedBox(height: 100),
                Image.asset('assets/images/no_posts_image.png', scale: 5.5),
                SizedBox(height: 15),
                Container(
                    child: Text(
                        "You haven't shared" + "\n anything yet",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold', fontSize: 23.0)
                    )
                ),
              ]
          )
      );
    }
    else if (postOrientation == "grid") {
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 1.5,
          crossAxisSpacing: 1.5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: gridTilesList
      );
    }
    else if (postOrientation == "list") {
      return Column(
        children: postsList,
      );
    }
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await postReference.document(widget.userProfileId).collection("usersPosts").orderBy("timestamp", descending: true).getDocuments();
    setState(() {
      loading = false;
      countPosts = querySnapshot.documents.length;
      postsList = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
    });
  }

  reloadProfilePosts() async {
    QuerySnapshot querySnapshot = await postReference.document(widget.userProfileId).collection("usersPosts").orderBy("timestamp", descending: true).getDocuments();
    setState(() {
      countPosts = querySnapshot.documents.length;
      postsList = querySnapshot.documents.map((documentSnapshot) => Post.fromDocument(documentSnapshot)).toList();
    });
  }

  createListAndGridPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            onPressed: () => setOrientation("grid"),
            icon: Icon(Icons.grid_on, size: 23),
            color: postOrientation == "grid" ? Color(0xFF05268D) : Color(0xFF99B6F2)
        ),
        IconButton(
            onPressed: () => setOrientation("list"),
            icon: Icon(Icons.list, size: 32),
            color: postOrientation == "list" ? Color(0xFF05268D) : Color(0xFF99B6F2)
        ),
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOrientation = orientation;
      getAllProfilePosts();
    });
  }

  displayFollowing(BuildContext context, {String userProfileId, String userUsrName, String userProfileName, String userProfileImg}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FollowingPage(userProfileId: userProfileId, userUsrName: userUsrName, userProfileImg: userProfileImg)));
  }

  displayFollowers(BuildContext context, {String userProfileId, String userUsrName, String userProfileName, String userProfileImg}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => FollowersPage(userProfileId: userProfileId, userUsrName: userUsrName, userProfileImg: userProfileImg)));
  }

  logoutUser(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              backgroundColor: Color(0xff607dd9),
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    height: 300,
                    width: 300,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                      child: Column(
                        children: [
                          Text("Do you want to sign out Favoury?", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 23),),
                          SizedBox(height: 30),
                          Container(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () => controlLogOut(context),
                              child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 45,
                                  width: 260,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(35)),
                                  child: Text("Sign Out", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratBold', fontSize: 15),
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Container(
                            alignment: Alignment.topCenter,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: AnimatedContainer(
                                  alignment: Alignment.center,
                                  duration: Duration(milliseconds: 300),
                                  height: 45,
                                  width: 260,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(35)),
                                  child: Text("Cancel", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratBold', fontSize: 15),
                                  )
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: -40,
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 40,
                        child: Icon(Icons.logout, color: Colors.white, size: 50,),
                      )
                  ),
                ],
              )
          );
        }
    );
  }

  controlLogOut(context) async {
    await gSignIn.signOut();
    AuthService().signOut();
    setState(() {
      isSignedIn = false;
      isSignedInByEmail = false;
    });
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => HomePage()),
            (Route<dynamic> route) => route is HomePage
    );
  }
}
