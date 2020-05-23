import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:wheelsponge/Pages/AddressForm.dart';

import '../Services/signInService.dart';
import 'HomePage.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  SignInService signInService = SignInService();
  bool _user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('WheelSponge'),
              GoogleSignInButton(
                onPressed: () {
                  signInService.signInWithGoogle();
//                  .whenComplete(() {
//                    _buildNextPage();
//                  });
                },
              ),
              FacebookSignInButton(
                onPressed: () {
                  signInService.signInWithFacebook();
//                      .whenComplete(() {
//                    _buildNextPage();
//                  });
                },
              ),
              MaterialButton(
                child: Text('Sign Out'),
                onPressed: signInService.signOut,
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildNextPage() async {
    print("---------------------- Building next page -----------------------");
    _user = await signInService.checkNewUser();
    print("===================User $_user");

    if (!_user) {
      print("user not found");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => AddressForm()));
    } else {
      print("user found");
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
