import 'dart:async';

import 'package:flutter/material.dart';
import 'package:postme_app/services/error_handler.dart';
import 'package:postme_app/services/authservice.dart';

import 'LoginPage.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final formKey = new GlobalKey<FormState>();

  String email;

  Color greenColor = Color(0xFF00AF19);

  updateUserData() {
    if (checkFields()) {
      AuthService().resetPasswordLink(email);
      Timer(Duration(seconds: 1), () {
        Navigator.pop(context);
      });
      SnackBar successSnackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please check your email to see how to reset your password!",
            textAlign: TextAlign.center, style: TextStyle(
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
      ScaffoldMessenger.of(context).showSnackBar(successSnackBar);
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Form(key: formKey, child: _buildResetForm())));
  }

  _buildResetForm() {
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
                        width: 230,
                        height: 73,
                        decoration: BoxDecoration(
                            color: Color(0xff607dd9),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text('Forgot',
                            style: TextStyle(
                                fontFamily: 'MontserratExtraBold',
                                fontSize: 50.0,
                                color: Colors.white
                            )
                        )
                    ),
                    Positioned(
                        top: 90.0,
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
                        top: 88.2,
                        left: 298.0,
                        child: Text(
                            '?',
                            style: TextStyle(
                                fontFamily: 'MontserratExtraBold',
                                fontSize: 43.0,
                                color: Color(0xff2949a9)
                            )
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
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff607dd9)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xff05268d)),
                      )),
                  onChanged: (value) {
                    this.email = value;
                  },
                  validator: (value) =>
                  value.isEmpty ? 'Email is required' : validateEmail(value)),
              SizedBox(height: 62.0),
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
                      child: Text("Reset", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 26))
                  ),
                ),
              ),
            ]
        )
    );
  }
}