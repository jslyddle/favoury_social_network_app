import 'package:flutter/material.dart';
import 'package:postme_app/pages/HomePage.dart';
import 'package:postme_app/pages/onboarding/Onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

int initScreen;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = await preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favoury',
      debugShowCheckedModeBanner: false,
      theme: ThemeData
      (
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Colors.white,
        primarySwatch: Colors.grey,
        cardColor: Colors.white70,
        accentColor: Colors.white,
      ),
      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
      routes: {
        'onboard' : (context) => Onboarding(),
        'home' : (context) => HomePage(),
      },
    );
  }
}
