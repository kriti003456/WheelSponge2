import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:wheelsponge/Pages/HomePage.dart';
import 'package:wheelsponge/Pages/signinPage.dart';
import 'package:wheelsponge/Services/locationService.dart';
import 'package:wheelsponge/Services/signInService.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    LocationService _locationService = LocationService();
    _locationService.getCurrentLocation();
    SignInService signInService = SignInService();
    return MaterialApp(
      title: 'WheelSponge',
      home: (signInService.firebaseUser == null) ? SignInPage(): HomePage(),
    );
  }
}
