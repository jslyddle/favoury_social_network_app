import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/NotificationsPage.dart';
import 'package:postme_app/pages/ProfilePage.dart';
import 'package:postme_app/pages/SearchPage.dart';
import 'package:postme_app/pages/TimeLinePage.dart';
import 'package:postme_app/pages/UploadPage.dart';
import 'package:postme_app/widgets/NavBarIconsWidget.dart';

class NavigationBar extends StatefulWidget {

  @override
  _NavigationBarState createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> with SingleTickerProviderStateMixin {

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: <Widget>[
          TimeLinePage(),
          SearchPage(),
          UploadPage(),
          NotificationsPage(),
          ProfilePage(userProfileId: currentUser?.id),
        ],
        controller: _tabController,
        //onPageChanged: whenPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      extendBody: true,
      bottomNavigationBar: Container(
        height: 135,
        padding: EdgeInsets.only(left: 37, right: 37, top: 40, bottom: 35),
        child: ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          child: Container(
            color: Color(0xff607dd9),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF99B6F2),
              labelStyle: TextStyle(fontSize: 10.0),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(color: Colors.black54, width:0.0),
              ),
              //For Indicator Show and Customization
              indicatorColor: Colors.black54,
              tabs: <Widget>[
                Tab(
                  icon: Icon(
                    NavBarIcons.home,
                    size: 20.0,
                  ),
                ),
                Tab(
                  icon: Icon(
                    NavBarIcons.magnifiying_glass,
                    size: 20.0,
                  ),
                ),
                Tab(
                  icon: Icon(
                    NavBarIcons.plus,
                    size: 30.0,
                  ),
                ),
                Tab(
                  icon: Icon(
                    NavBarIcons.like,
                    size: 20.0,
                  ),
                ),
                Tab(
                  icon: Icon(
                    NavBarIcons.user,
                    size: 20.0,
                  ),
                ),
              ],
              controller: _tabController,
            ),
          ),
        ),
      ),
    );
  }
}