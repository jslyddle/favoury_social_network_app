import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:postme_app/widgets/HeaderWidget.dart';
import 'package:tiengviet/tiengviet.dart';

import 'HomePage.dart';
import 'login/SignUpPage.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  String userName;
  final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;

  submitUserName() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      SnackBar snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Welcome " + TiengViet.parse(userName).replaceAll(' ', '').toLowerCase() + "!", textAlign: TextAlign.center, style: TextStyle(
          color: Colors.white,
          fontFamily: 'MontserratSemiBold',
          fontSize: 18.5,
        )),
        backgroundColor: Color(0xff607dd9),
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 17),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25))
        ),
      );
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context, TiengViet.parse(userName).replaceAll(' ', '').toLowerCase().toLowerCase());
      });
    }
  }

  goSignIn() {
    if (isSignedInByEmail == true) {
      userName = currentName;
    }
    else {
      userName = TiengViet.parse(gCurrentUser.displayName).replaceAll(' ', '').toLowerCase();
    }
    Timer(Duration(seconds: 1), (){
      Navigator.pop(context, userName);
    });
    SnackBar snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text("Welcome " + userName + "!",textAlign: TextAlign.center, style: TextStyle(
        color: Colors.white,
        fontFamily: 'MontserratSemiBold',
        fontSize: 18.5,
      )),
      backgroundColor: Color(0xff607dd9),
      margin: EdgeInsets.only(left: 30, right: 30, bottom: 17),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25))
      ),
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext parentContext) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: ListView(
            children: [
              SizedBox(height: 65.0),
              Image.asset('assets/images/username_image.png', scale: 0.77),
              Container(
                padding: const EdgeInsets.only(top: 25.0,left: 13.0, right: 13.0),
                child: Text("Before going to the world of Favoury, let's give yourself a username so people can interact with you", textAlign: TextAlign.center, style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratRegular', fontSize: 16),)
              ),
              SizedBox(height: 57.0),
              Container(
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: TextFormField(
                      validator: (val) {
                        if (val.trim().length < 5 || val.isEmpty) {
                          return "Please choose a longer username";
                        }
                        else if (val.trim().length > 15) {
                          return "Please choose a shorter username";
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (val) => userName = val,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          labelStyle: TextStyle(
                              fontFamily: 'MontserratSemiBold',
                              fontSize: 18.0,
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
                  )
              ),
              SizedBox(height: 40.0),
              Container(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: submitUserName,
                  child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      height: 60,
                      width: 305,
                      decoration: BoxDecoration(
                          color: Color(0xff607dd9),
                          borderRadius: BorderRadius.circular(35)),
                      child: Text("Set Username", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 26),
                      )
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              GestureDetector(
                  onTap: goSignIn,
                  child: Container(
                      alignment: Alignment(0.0, 0.0),
                      child: InkWell(
                          child: Text("Skip",
                              style: TextStyle(
                                color: Color(0xff607dd9),
                                fontFamily: 'MontserratSemiBold',
                                fontSize: 18.0,
                              )
                          )
                      )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}


