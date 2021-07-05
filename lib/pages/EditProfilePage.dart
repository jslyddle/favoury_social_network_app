import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/ProfilePage.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';



class EditProfilePage extends StatefulWidget {
  final String currentOnlineUserId;
  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;
  bool _bioValid = true;

  void initState() {
    super.initState();

    getAndDisplayUserInfo();
  }

  getAndDisplayUserInfo() async {
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot = await userReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);
    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;

    setState(() {
      loading = false;
    });
  }

  updateUserData() {
    setState(() {
      profileNameTextEditingController.text
          .trim()
          .length < 3 ||
          profileNameTextEditingController.text.isEmpty
          ? _profileNameValid = false : _profileNameValid = true;

      bioTextEditingController.text
          .trim()
          .length > 110
          ? _bioValid = false : _bioValid = true;
    });

    if (_profileNameValid && _bioValid) {
      userReference.document(widget.currentOnlineUserId).updateData({
        "profileName": profileNameTextEditingController.text,
        "bio": bioTextEditingController.text
      });
      // ignore: deprecated_member_use
      Timer(Duration(seconds: 1), (){
        Navigator.pop(context);
      });
      SnackBar successSnackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Your Favoury has been updated successfully!", textAlign: TextAlign.center, style: TextStyle(
          color: Colors.white,
          fontFamily: 'MontserratSemiBold',
          fontSize: 15,
        )),
        backgroundColor: Color(0xff607dd9),
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 17),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))
        ),
      );
      _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      body: loading ? circularProgress() : ListView(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        children: <Widget>[
          SizedBox(height: 80),
          Container(
            alignment: Alignment.topLeft,
            child: GestureDetector(
                onTap: () {
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black)
                )
            ),
          ),
          SizedBox(height: 32.0),
          Container(
            height: 128.0,
            width: 200.0,
            child: Stack(
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 135,
                    height: 66,
                    decoration: BoxDecoration(
                        color: Color(0xff607dd9),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text('Edit',
                        style: TextStyle(
                            fontFamily: 'MontserratExtraBold',
                            fontSize: 45.0,
                            color: Colors.white
                        )
                    )
                ),
                Positioned(
                    top: 75.0,
                    left: 12,
                    child: Text(
                        'My Favoury',
                        style: TextStyle(
                            fontFamily: 'MontserratExtraBold',
                            fontSize: 34.0
                        )
                    )
                ),
                Positioned(
                    top: 100.0,
                    left: 227.0,
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff2949a9)
                      ),
                    )
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 18.0, bottom: 12.0),
                  child: CircleAvatar(
                      radius: 65.0,
                      backgroundImage: CachedNetworkImageProvider(user.url)
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 50),
                  child: Column(children: <Widget>[
                    SizedBox(height: 17),
                    createProfileNameTextFormField(),
                    SizedBox(height: 25),
                    createBioTextFormField()
                  ],),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: updateUserData,
                    child: AnimatedContainer(
                        alignment: Alignment.center,
                        duration: Duration(milliseconds: 300),
                        height: 60,
                        width: 305,
                        decoration: BoxDecoration(
                            color: Color(0xff607dd9),
                            borderRadius: BorderRadius.circular(35)),
                        child: Text("Update", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 26),
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container createProfileNameTextFormField() {
    return Container(
      child: TextFormField(
        controller: profileNameTextEditingController,
        decoration: InputDecoration(
          errorText: _profileNameValid ? null : "Profile name is very short",
          labelText: 'New Profile Name',
          labelStyle: TextStyle(
              fontFamily: 'MontserratSemiBold',
              fontSize: 18.0,
              color: Color(0xff607dd9).withOpacity(0.65)),
          hintText: "Type your profile name here...",
          hintStyle: TextStyle(
              fontFamily: 'MontserratMedium',
              fontSize: 14.0,
              color: Color(0xff607dd9).withOpacity(0.65)),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff607dd9)),
              borderRadius: BorderRadius.all(Radius.circular(28))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff05268d)),
              borderRadius: BorderRadius.all(Radius.circular(28))
          ),
        ),
      ),
    );
  }

  Container createBioTextFormField() {
    return Container(
      child: TextFormField(
        controller: bioTextEditingController,
        decoration: InputDecoration(
          errorText: _bioValid ? null : "Bio is very long",
          labelText: 'New Bio',
          labelStyle: TextStyle(
              fontFamily: 'MontserratSemiBold',
              fontSize: 18.0,
              color: Color(0xff607dd9).withOpacity(0.65)),
          hintText: "Type your bio here...",
          hintStyle: TextStyle(
              fontFamily: 'MontserratMedium',
              fontSize: 14.0,
              color: Color(0xff607dd9).withOpacity(0.65)),
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(28))),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff607dd9)),
              borderRadius: BorderRadius.all(Radius.circular(28))
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff05268d)),
              borderRadius: BorderRadius.all(Radius.circular(28))
          ),
        ),
      ),
    );
  }
}
