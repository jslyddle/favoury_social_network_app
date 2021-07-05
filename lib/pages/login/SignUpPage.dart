import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/CreateAccountPage.dart';
import 'package:postme_app/services/error_handler.dart';
import 'package:postme_app/services/authservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postme_app/widgets/NavBarIconsWidget.dart';
import 'package:tiengviet/tiengviet.dart';

import '../HomePage.dart';
import 'LoginPage.dart';

bool isSignedInByEmail = false;
String currentName;

class SignUpPage extends StatefulWidget {

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final _firestore = Firestore.instance;

  final formKey = new GlobalKey<FormState>();

  final pattern = RegExp('\\s+');

  String email, password, profile;

  //To check fields during submit
  checkFields() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //To Validate email
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter valid email';
    else
      return null;
  }

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(key: formKey, child: _buildSignupForm())
        )
    );
  }

  _buildSignupForm() {
    return Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
        child: ListView(
            children: [
              SizedBox(height: 30),
              Container(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black),
                      )
                  ),
                ),
              SizedBox(height: 45.0),
              Container(
                height: 150.0,
                width: 250.0,
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: 265,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Color(0xff607dd9),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text('Sign Up',
                            style: TextStyle(
                                fontFamily: 'MontserratExtraBold',
                                fontSize: 55.0,
                                color: Colors.white
                            )
                        )
                    ),
                    Positioned(
                        top: 93.0,
                        left: 12,
                        child: Text(
                            'Your Favoury',
                            style: TextStyle(
                                fontFamily: 'MontserratExtraBold',
                                fontSize: 40.0
                            )
                        )
                    ),
                    Positioned(
                        top: 123.5,
                        left: 295.0,
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
              SizedBox(height: 45.0),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                  onChanged: (value) {
                    this.email = value;
                  },
                  validator: (value) =>
                  value.isEmpty ? 'Email is required' : validateEmail(value)),
              SizedBox(height: 25.0),
              TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Profile Name',
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
                  onChanged: (value) {
                    this.profile = value;
                  },
                  validator: (value) =>
                  value.isEmpty ? 'Profile is required' : null),
              SizedBox(height: 25.0),
              Container(
                height: 81.0,
                width: 250.0,
                child: Stack(
                  children: [
                    Container(
                      width: 287,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                        obscureText: _obscureText,
                        onChanged: (value) {
                          this.password = value;
                        },
                        validator: (value) =>
                        value.isEmpty ? 'Password is required' : null,
                      ),
                    ),
                    Positioned(
                        top: 17.5,
                        left: 298.0,
                        child: GestureDetector(onTap: () {
                          _toggle();
                        }, child: (_obscureText) ? Icon(NavBarIcons.view, size: 27, color: Color(0xff607dd9)
                        ) : Icon(NavBarIcons.invisible_symbol, size: 27, color: Color(0xff607dd9)))),
                  ],
                ),
              ),
              SizedBox(height: 35.0),
              Container(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () => saveInfoToFireStore(),
                  child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      height: 60,
                      width: 305,
                      decoration: BoxDecoration(
                          color: Color(0xff607dd9),
                          borderRadius: BorderRadius.circular(35)),
                      child: Text("Sign Up", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 26),
                      )
                  ),
                ),
              ),
            ]
        )
    );
  }

  saveInfoToFireStore() {
    if (checkFields())
      AuthService().signUp(email, password, profile).then((signedInUser) async {
        final FirebaseAuth auth = FirebaseAuth.instance;

        final FirebaseUser user = await auth.currentUser();

        final uid = user.uid;

        _firestore.collection('users')
            .document(uid)
            .setData({
          "id": uid,
          "email": email,
          "bio": "I love Favoury!",
          "profileName": profile,
          "timestamp": DateTime.now(),
          "url": "https://nepalirhinosallstars.com/wp-content/uploads/2021/06/360_F_64676383_LdbmhiNM6Ypzb3FM4PPuFP9rHe7ri8Ju.jpg",
          "username": TiengViet.parse(profile).replaceAll(' ', '').toLowerCase()
        })
            .then((value) async {
          if (signedInUser != null) {

            setState(() {
              isSignedInByEmail = true;
              currentName = TiengViet.parse(profile).replaceAll(' ', '').toLowerCase();
            });

            final username = await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => CreateAccountPage()));

            _firestore.collection('users')
                .document(uid)
                .updateData({
              "username": username
            });

            DocumentSnapshot documentSnapshot = await userReference.document(uid).get();
            currentUser = User.fromDocument(documentSnapshot);
            setState(() {
              isSignedIn = true;
            });

            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => route is HomePage
            );
          }
        }).catchError((e) {
          ErrorHandler().errorDialog(context, e);
        });
      },
      );
  }
}
