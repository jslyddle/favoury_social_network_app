import 'package:flutter/material.dart';
import 'SignInPage.dart';
import 'SignUpPage.dart';
import 'ForgotPasswordPage.dart';
import 'package:postme_app/pages/HomePage.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 25.0, right: 25.0),
          child: ListView(
            children: [
              SizedBox(height: 80.0),
              Container(
                height: 150.0,
                width: 200.0,
                child: Stack(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        width: 200,
                        height: 80,
                        decoration: BoxDecoration(
                            color: Color(0xff607dd9),
                            borderRadius: BorderRadius.circular(30)),
                        child: Text('Hello',
                            style: TextStyle(
                                fontFamily: 'MontserratExtraBold',
                                fontSize: 60.0,
                                color: Colors.white
                            )
                        )
                    ),
                    Positioned(
                        top: 85.0,
                        left: 17,
                        child: Text(
                            'There',
                            style: TextStyle(
                                fontFamily: 'MontserratExtraBold',
                                fontSize: 60.0
                            )
                        )
                    ),
                    Positioned(
                        top: 131.5,
                        left: 207.0,
                        child: Container(
                          height: 12.5,
                          width: 12.5,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff2949a9)
                          ),
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100),
              Container(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInPage(),
                          ),
                        );
                      },
                      child: AnimatedContainer(
                          alignment: Alignment.center,
                          duration: Duration(milliseconds: 300),
                          height: 68,
                          width: 305,
                          decoration: BoxDecoration(
                              color: Color(0xff607dd9),
                              borderRadius: BorderRadius.circular(35)),
                          child: Text("Login", style: TextStyle(color: Colors.white, fontFamily: 'MontserratBold', fontSize: 28),
                          )
                      ),
                    ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.topCenter,
                      child: GestureDetector(
                        onTap: () {
                          gSignIn.signIn();
                        },
                        child: AnimatedContainer(
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 300),
                            height: 68,
                            width: 305,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xff607dd9),
                                width: 3
                              ),
                                color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(35))),
                            child: Row (
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/google_logo.png', scale: 4),
                                SizedBox(width: 10),
                                Text("Log in with Google", style: TextStyle(color: Color(0xff607dd9), fontFamily: 'MontserratBold', fontSize: 21),)
                              ],
                            )
                        ),
                      ),
                    ),
                    SizedBox(height: 90),
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
                    SizedBox(height: 85),
                    Image.asset('assets/images/login_logo.png', scale: 1.8),
                  ],
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
