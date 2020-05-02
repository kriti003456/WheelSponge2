//import 'dart:convert' as JSON;
//
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:http/http.dart' as http;
//
//class FacebookLoginFunctionality {
//  final facebookLogin = FacebookLogin();
//
//  Future<Map> _loginWithFB() async {
//
//    Map userProfile;
//    final result = await facebookLogin.logIn(['email']);
//
//    switch (result.status) {
//      case FacebookLoginStatus.loggedIn:
//        final token = result.accessToken.token;
//        final graphResponse = await http.get(
//            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
//        userProfile = JSON.jsonDecode(graphResponse.body);
//        print(userProfile);
//        break;
//      case FacebookLoginStatus.cancelledByUser:
//        return null;
//      case FacebookLoginStatus.error:
//        return null;
//    }
//    return Future.delayed(const Duration(milliseconds: 100), () => userProfile);
//  }
//
//  void _logoutFacebook() {
//    facebookLogin.logOut();
//  }
//}

//import 'package:flutter/material.dart';
//
//void main() => runApp(new MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return new MaterialApp(
//      theme: new ThemeData(primarySwatch: Colors.amberAccent[100]),
//      home: new LoginPage(),
//    );
//  }
//}
//
//class LoginPage extends StatefulWidget {
//  @override
//  State createState(){
//    return LoginPageState();
//  }
//}
//
//class LoginPageState extends State<LoginPage>
//    with SingleTickerProviderStateMixin {
//  Animation<double> _iconAnimation;
//  AnimationController _iconAnimationController;
//
//  @override
//  void initState() {
//    super.initState();
//    _iconAnimationController = new AnimationController(
//        vsync: this, duration: new Duration(milliseconds: 500));
//    _iconAnimation = new CurvedAnimation(
//      parent: _iconAnimationController,
//      curve: Curves.bounceOut,
//    );
//    _iconAnimation.addListener(() => this.setState(() {}));
//    _iconAnimationController.forward();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        backgroundColor: Colors.white,
//        body: new Stack(
//          fit: StackFit.expand,
//          children: <Widget>[
////          new Theme(
////            data: new ThemeData(
////              inputDecorationTheme: new InputDecorationTheme(
////
////              ),
////            )
////          ),
//        new Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            new FlutterLogo(
//              size: _iconAnimation.value * 140.0,
//            ),
//
//          ],
//        );
//    );
//  }
//}
