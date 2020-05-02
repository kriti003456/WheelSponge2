import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

import 'state_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
//    with SingleTickerProviderStateMixin {
//  AnimationController _iconAnimationController;
//  Animation<double> _iconAnimation;

//  @override
//  void initState() {
//    super.initState();
//    _iconAnimationController = new AnimationController(
//        vsync: this, duration: new Duration(milliseconds: 500));
//    _iconAnimation = new CurvedAnimation(
//      parent: _iconAnimationController,
//      curve: Curves.bounceOut
//    );
//  }

  @override
  Widget build(BuildContext context) {
    Text _buildText() {
      return Text(
        'WheelSponge',
        style: Theme.of(context).textTheme.headline,
        textAlign: TextAlign.center,
      );
    }

    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildText(),
              SizedBox(height: 50.0),
              GoogleSignInButton(
                // Passing function callback as constructor argument:
                onPressed: () => StateWidget.of(context).signInWithGoogle(),
              ),
              FacebookSignInButton(
                onPressed: () => StateWidget.of(context).signInWithFacebook(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
