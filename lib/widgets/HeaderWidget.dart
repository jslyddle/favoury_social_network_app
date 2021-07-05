import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle = false, String strTitle, disappearBackButton = false}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Color(0xFF05268D),
    ),
    automaticallyImplyLeading: disappearBackButton ? false : true,
    title: Text(
      isAppTitle ? "Favoury" : strTitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Color(0xFF05268D),
        fontFamily: isAppTitle ? "PacificoRegular" : "MontserratBold",
        fontSize: isAppTitle ? 30.0 : 23.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}
