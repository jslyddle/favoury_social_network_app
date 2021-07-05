import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/CommentsPage.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/ProfilePage.dart';
import 'package:postme_app/pages/UploadPage.dart';
import 'package:postme_app/widgets/CImageWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;

int countTotalComments = 0;

class Post extends StatefulWidget {
  final String postId;
  final String ownerId;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;
  final Timestamp timestamp;


  Post({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.timestamp,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot) {
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      username: documentSnapshot["username"],
      description: documentSnapshot["description"],
      location: documentSnapshot["location"],
      url: documentSnapshot["url"],
      timestamp: documentSnapshot["timestamp"]
    );
  }

  int getTotalNumberOfLikes(likes) {
    if (likes == null) {
      return 0;
    }
    int counter = 0;
    likes.values.forEach((eachValue) {
      if (eachValue == true) {
        counter++;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    likes: this.likes,
    username: this.username,
    description: this.description,
    location: this.location,
    url: this.url,
    likesCount: getTotalNumberOfLikes(this.likes),
    timestamp: this.timestamp
  );
}

class _PostState extends State<Post> {
  final String postId;
  final String ownerId;
  Map likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likesCount;
  int commentsCount = 0;
  bool isLiked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser?.id;
  final Timestamp timestamp;


  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likesCount,
    this.commentsCount,
    this.timestamp
  });

  @override
  Widget build(BuildContext context) {
    isLiked = (likes[currentOnlineUserId] == true);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createPostHead(),
          createPostPicture(),
          createPostFooter()
        ],
      ),
    );
  }

  createPostHead() {
    return FutureBuilder(
      future: userReference.document(ownerId).get(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = (currentOnlineUserId == ownerId);
        return ListTile(
          leading: CircleAvatar(backgroundImage: CachedNetworkImageProvider(user.url), backgroundColor: Colors.grey),
          title: GestureDetector(
            onTap: () => displayUserProfile(context, userProfileId: user.id, userUsrName: user.username, userProfileImg: user.url),
            child: Text(
                user.username,
                style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold')
            ),
          ),
          subtitle: Text(location, style: TextStyle(fontFamily: 'MontserratMedium',color: Color(0xFF5F7ED9))),
          trailing: isPostOwner ? IconButton(
              icon: Icon(Icons.more_vert, color: Color(0xFF2849A6)),
              onPressed: () => controlPostDelete(context),
          ) : Text(""),
        );
      },
    );
  }

  controlPostDelete(BuildContext mContext) {
    return showDialog(
        context: mContext,
        builder: (context) {
          return SimpleDialog(
            title: Text("Favour Options",style: TextStyle(color: Color(0xFF05268D), fontFamily: "MontserratBold")),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Delete", style: TextStyle(color: Color(0xFF05268D), fontFamily: "MontserratRegular")),
                onPressed: () {
                  Navigator.pop(context);
                  removeUserPost();
                },
              ),
              SimpleDialogOption(
                child: Text("Cancel", style: TextStyle(color: Color(0xFF05268D), fontFamily: "MontserratRegular")),
                onPressed: () => Navigator.pop(context)
              ),
            ],
          );
        }
    );
  }

  removeUserPost() async {
    postReference.document(ownerId).collection("usersPosts").document(postId).get()
        .then((document) {
          if ((document).exists) {
            document.reference.delete();
          }
    });

    storageReference.child("post_$postId.jpg").delete();

    QuerySnapshot querySnapshot =  await activityFeedReference.document(ownerId)
        .collection("feedItems")
        .where("postId", isEqualTo: postId).getDocuments();

    querySnapshot.documents.forEach((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    QuerySnapshot commentQuerySnapshot = await commentsReference.document(postId).collection("comments").getDocuments();
    commentQuerySnapshot.documents.forEach((document) {
      document.reference.delete();
    });
  }

  removeLike() {
    bool isNotPostOwner = (currentOnlineUserId != ownerId);
    if (isNotPostOwner) {
      activityFeedReference.document(ownerId).collection("feedItems").document(postId).get().then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    }
  }

  addLike() {
    bool isNotPostOwner = (currentOnlineUserId != ownerId);
    if (isNotPostOwner) {
      activityFeedReference.document(ownerId).collection("feedItems").document(postId).setData({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "timestamp": DateTime.now(),
        "url": url,
        "postId": postId,
        "userProfileImg": currentUser.url,
      });
    }
  }

  controlUserLikesPost() {
    bool _liked = (likes[currentOnlineUserId] == true);
    if (_liked) {
      postReference.document(ownerId).collection("usersPosts").document(postId).updateData({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likesCount --;
        isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    }
    else if (!_liked) {
      postReference.document(ownerId).collection("usersPosts").document(postId).updateData({"likes.$currentOnlineUserId": true});
      addLike();
      setState(() {
        likesCount++;
        isLiked = true;
        likes[currentOnlineUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), (){
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  createPostPicture() {
    return GestureDetector(
      onDoubleTap: () => controlUserLikesPost(),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(url),
          showHeart ? Icon(Icons.favorite, size: 100.0, color: Colors.white) : Text(""),
        ],
      ),
    );
  }

  reloadTotalComments() async {
    QuerySnapshot querySnapshot = await commentsReference.document(postId)
        .collection("comments")
        .getDocuments();
    setState(() {
      countTotalComments = querySnapshot.documents.length;
      commentsCount = countTotalComments;
    });
  }

  createPostFooter() {
    reloadTotalComments();
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50.0, left: 18.0)),
            GestureDetector(
              onTap: () => controlUserLikesPost(),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 30.0,
                color: Colors.pink,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 15.0)),
            Row(
              children: [
                GestureDetector(
                    onTap: () => displayComments(context, postId: postId, ownerId: ownerId, url: url),
                    child: Icon(Icons.chat_bubble_outline, size: 28.0, color: Color(0xFF2849A6))
                ),
                Padding(padding: EdgeInsets.only(left: 8.0)),
                GestureDetector(
                  onTap: () => displayComments(context, postId: postId, ownerId: ownerId, url: url),
                  child: Text(
                    "view all $commentsCount comments",
                    style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold'),
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 21.0),
              child: Text(
                  "$likesCount likes",
                  style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold')
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 21.0, top: 2.0),
              child: Text(
                  "$username ",
                  style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold')
              ),
            ),
            Expanded(
                child: Text(description, style: TextStyle(color: Color(0xFF2849A6), fontFamily: 'MontserratMedium'))
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 21.0, top: 10.0),
              child: Text(
                  tAgo.format(timestamp.toDate()),
                  style: TextStyle(color: Color(0xFF5F7ED9))
              ),
            ),
          ],
        ),
      ],
    );
  }

  displayComments(BuildContext context, {String postId, String ownerId, String url}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => CommentsPage(postId: postId, postOwnerId: ownerId, postImageUrl: url))).then((value) => setState(() {}));
  }

  displayUserProfile(BuildContext context, {String userProfileId, String userUsrName, String userProfileImg}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userProfileId, userUsrName: userUsrName,  userProfileImg: userProfileImg)));
  }
}
