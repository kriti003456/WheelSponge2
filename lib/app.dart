import 'package:flutter/material.dart';
import 'package:wheelsponge/Pages/HomePage.dart';
import 'package:wheelsponge/Pages/signinPage.dart';
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WheelSponge',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => HomePage(),
        '/login': (context) => SignInPage(),
      },
    );
  }
}