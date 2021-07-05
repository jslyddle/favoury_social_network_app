import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postme_app/models/user.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/ProfilePage.dart';
import 'package:postme_app/widgets/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResult;

  emptyTextFormField() {
    searchTextEditingController.clear();
    setState(() {
      futureSearchResult = null;
    });
  }

  controlSearching(String strSearch) {
    Future<QuerySnapshot> allUsers = userReference.where("username", isGreaterThanOrEqualTo: strSearch.replaceAll(' ', '').toLowerCase()).where("username", isLessThanOrEqualTo: (strSearch + '\uf8ff').replaceAll(' ', '').toLowerCase()).getDocuments();
    setState(() {
      futureSearchResult = allUsers;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title:
      Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 12),
            child: Icon(Icons.person_pin, color: Color(0xff607dd9), size: 40.0),

          ),
          Positioned(
            left: 48,
            bottom: 16 ,
            width: 270,
            height: 35,
            child: TextFormField(
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16.5, fontFamily: 'MontserratMedium', color: Color(0xff607dd9)),
                controller: searchTextEditingController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 12, right: 12),
                  hintText: "Search people here...",
                  hintStyle: TextStyle(fontFamily: 'MontserratMedium', color: Color(0xff607dd9)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff607dd9)),
                      borderRadius: BorderRadius.all(Radius.circular(28))
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff05268d)),
                      borderRadius: BorderRadius.all(Radius.circular(28))
                  ),
                ),
                onFieldSubmitted: controlSearching
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 316, bottom: 12),
              child: IconButton(icon: Icon(Icons.clear, color: Color(0xff607dd9), size: 37.0), onPressed: emptyTextFormField)
          ),
        ],
      ),
    );
  }

  Container displayNoSearchResultScreen() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Column(
            children: [
              SizedBox(height: 245),
              Image.asset('assets/images/search_image.png', scale: 4.5),
              SizedBox(height: 15),
              Container(
                  child: Text(
                      "Who's using Favoury?",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFF05268D), fontFamily: 'MontserratSemiBold', fontSize: 23.0)
                  )
              ),
            ]
        )
    );
  }

  displayUsersFoundScreen() {
    return FutureBuilder(
      future: futureSearchResult,
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }

        List<UserResult> searchUserResult = [];
        dataSnapshot.data.documents.forEach((document){
          User eachUser = User.fromDocument(document);
          UserResult userResult = UserResult(eachUser);
          searchUserResult.add(userResult);
        });

        return ListView(children: searchUserResult);
      },
    );
  }

  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: searchPageHeader(),
        body: futureSearchResult == null ? displayNoSearchResultScreen() : displayUsersFoundScreen()
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 7.0, left: 13.0, right: 13.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(33),
            color: Color(0xff607dd9).withOpacity(0.8)
        ),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => displayUserProfile(context, userProfileId: eachUser.id, userUsrName: eachUser.username, userProfileImg: eachUser.url),
              child: ListTile(
                leading: CircleAvatar(backgroundColor: Colors.black, backgroundImage: CachedNetworkImageProvider(eachUser.url)),
                title: Text(eachUser.username, style: TextStyle(
                    color: Colors.white,fontFamily: 'MontserratSemiBold', fontSize: 17.0
                ),),
                subtitle: Text(eachUser.profileName, style: TextStyle(
                    color: Colors.white,fontFamily: 'MontserratMedium', fontSize: 13.0
                ),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserProfile(BuildContext context, {String userProfileId, String userUsrName, String userProfileImg}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userProfileId: userProfileId, userUsrName: userUsrName,  userProfileImg: userProfileImg)));
  }
}