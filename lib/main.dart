//import 'dart:convert' as JSON;
//
//import 'package:flutter/material.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:google_sign_in/google_sign_in.dart';
//import 'package:http/http.dart' as http;
//import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
//import 'facebookLogin.dart';
//import 'googleLogin.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatefulWidget {
//  @override
//  State<StatefulWidget> createState() {
//    // TODO: implement createState
//    return _MyAppState();
//  }
//}
//
//
//class _MyAppState extends State<MyApp> {
//  bool _isFacebookLoggedIn = false;
//  Map userProfile;
//  bool _isGoogleLoggedIn = false;
//
//  final facebook =FacebookLoginFunctionality();
//  final google = GoogleLoginFunctionality();
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return MaterialApp(
//      home: Scaffold(
//        body: Center(
//            child: _isFacebookLoggedIn
//                ? Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Image.network(
//                  userProfile["picture"]["data"]["url"],
//                  height: 50.0,
//                  width: 50.0,
//                ),
//                Text(userProfile["name"]),
//                OutlineButton(
//                  child: Text("Logout"),
//                  onPressed: () {
//                    facebook._logoutFacebook();
//                  },
//                )
//              ],
//            )
//                : ((_isGoogleLoggedIn)
//                ? (Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                Image.network(
//                  _googleSignIn.currentUser.photoUrl,
//                  height: 50.0,
//                  width: 50.0,
//                ),
//                Text(_googleSignIn.currentUser.displayName),
//                OutlineButton(
//                  child: Text("Logout"),
//                  onPressed: () {
//                    google._logoutGoogle();
//                  },
//                )
//              ],
//            ))
//                : Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//              children: <Widget>[
//                FacebookSignInButton(
//                  onPressed: () {
//                    facebook._loginWithFB();
//                  },
//                ),
//                GoogleSignInButton(
//                  onPressed: () {
//                    _loginWithGoogle();
//                  },
//                )
//              ],
//            ))),
//      ),
//    );
//  }
//}
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
//
//class GoogleLoginFunctionality{
//  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
//
//  Future<GoogleSignInAccount> _loginWithGoogle() async {
//    GoogleSignInAccount account;
//    try {
//      account = await _googleSignIn.signIn();
//    } catch (err) {
//      print("------login failed");
//      print(err);
//    }
//    return account;
//  }
//
//  _logoutGoogle() {
//    _googleSignIn.signOut();
//
//  }




import 'package:flutter/material.dart';
import 'app.dart';
import 'state_widget.dart';

void main(){
  StateWidget stateWidget = new StateWidget(child:new MyApp());
  runApp(stateWidget);
}
