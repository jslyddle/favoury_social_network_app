import 'package:flutter/material.dart';
import 'package:postme_app/models/slider.dart';
import 'package:postme_app/pages/login/LoginPage.dart';

import '../HomePage.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  int _currentPage = 0;
  PageController _controller = PageController();

  List<Widget> _pages = [
    SliderPage(
        title: "Live with moments",
        description:
        "Post photos with friends and family to be immersed in those wonderful moments!",
        image: 'assets/images/onboarding1.png'),
    SliderPage(
        title: "Make New Friends",
        description:
        "Exchange and make many new people into your friend groups.",
        image: 'assets/images/onboarding2.png'),
    SliderPage(
        title: "Increase Intimacy",
        description:
        "Let's increase feelings together with friends, relatives and ourselves.",
        image: 'assets/images/onboarding3.png'),
  ];

  _onchanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView.builder(
            scrollDirection: Axis.horizontal,
            onPageChanged: _onchanged,
            controller: _controller,
            itemCount: _pages.length,
            itemBuilder: (context, int index) {
              return _pages[index];
            },
          ),

          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.topRight,
            padding: EdgeInsets.fromLTRB(0, 75, 40, 0),

            child: (_currentPage != _pages.length - 1) ? GestureDetector(
              onTap: () {
                _controller.animateToPage(_pages.length -1, duration: Duration(milliseconds: 400), curve: Curves.linear);
              },
              child: Text("Skip", style: TextStyle(color: Colors.black, fontFamily: 'MontserratMedium', fontSize: 17),
              ),
            ) : Container(
              child: Text(""),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List<Widget>.generate(_pages.length, (int index) {
                    return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        height: 10,
                        width: (index == _currentPage) ? 30 : 10,
                        margin:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: (index == _currentPage)
                                ? Colors.blue
                                : Colors.blue.withOpacity(0.5)));
                  })),
              InkWell(
                child: (_currentPage == (_pages.length - 1))
                    ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      height: 70,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(35)),
                      child: Text("Get Started!", style: TextStyle(color: Colors.white, fontFamily: 'MontserratSemiBold', fontSize: 20),
                      )
                  ),
                )
                    : GestureDetector(
                    onTap: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 800),
                          curve: Curves.easeInOutQuint);
                    },
                    child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: Duration(milliseconds: 300),
                      height: 70,
                      width: 75,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(35)),
                      child: Icon(
                        Icons.navigate_next,
                        size: 50,
                        color: Colors.white,
                      ),
                    )
                ),
              ),
              SizedBox(
                height: 85,
              )
            ],
          ),
        ],
      ),
    );
  }
}
