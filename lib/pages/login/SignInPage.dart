import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/login/ForgotPasswordPage.dart';
//import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:postme_app/pages/login/LoginPage.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/services/authservice.dart';
import 'package:postme_app/services/error_handler.dart';
import 'package:postme_app/widgets/NavBarIconsWidget.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';

import 'SignUpPage.dart';

//import '../home_page.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  final formKey = new GlobalKey<FormState>();

  String email, password;

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
            child: Form(key: formKey, child: _buildLoginForm())
        )
    );
  }

  _buildLoginForm() {
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
                  child: Icon(Icons.arrow_back_ios, size: 35, color: Colors.black)
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
                    width: 245,
                    height: 80,
                    decoration: BoxDecoration(
                        color: Color(0xff607dd9),
                        borderRadius: BorderRadius.circular(30)),
                    child: Text('Sign In',
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
          SizedBox(height: 40.0),
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
              value.isEmpty ? 'Email is required' : validateEmail(value)
          ),
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
          SizedBox(height: 5.0),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push( MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
              },
              child: Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(right: 6.0),
                  child: InkWell(
                      child: Text('Forgot Password',
                          style: TextStyle(
                            color: Color(0xff607dd9),
                            fontFamily: 'MontserratSemiBold',
                            fontSize: 15.0,
                          )
                      )
                  )
              )
          ),
          SizedBox(height: 43.0),
          Container(
            alignment: Alignment.topCenter,
            child: GestureDetector(
              onTap: () => controlSignIn(),
              child: AnimatedContainer(
                  alignment: Alignment.center,
                  duration: Duration(milliseconds: 300),
                  height: 60,
                  width: 305,
                  decoration: BoxDecoration(
                      color: Color(0xff607dd9),
                      borderRadius: BorderRadius.circular(35)),
                  child: Text("Login", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 26),
                  )
              ),
            ),
          ),
          SizedBox(height: 60.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("New to Favoury?", style: TextStyle(color: Color(0xff333333), fontFamily: 'MontserratRegular', fontSize: 19),),
              SizedBox(width: 5),
              Container(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: Text("Register", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratSemiBold', fontSize: 19),
                      )
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  controlSignIn() {
    if (checkFields()) {
      AuthService().signIn(email, password, context).then((val) async {
        final FirebaseAuth auth = FirebaseAuth.instance;

        final FirebaseUser user = await auth.currentUser();

        final uid = user.uid;

        if (val != null) {
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
    }
  }
}