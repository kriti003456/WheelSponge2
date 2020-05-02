import 'dart:async';
import 'dart:convert' as JSON;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'auth.dart';
import 'state.dart';

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  // Returns data of the nearest widget _StateDataWidget
  // in the widget tree.
  static _StateWidgetState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_StateDataWidget)
            as _StateDataWidget)
        .data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;
  Map facebookProfile;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final facebookLogin = FacebookLogin();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      initUser();
    }
  }

  Future<Null> initUser() async {
    googleAccount = await getSignedInAccount(googleSignIn);
    if (googleAccount == null) {
      setState(() {
        state.isLoading = false;
      });
    } else {
      await signInWithGoogle();
    }
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      googleAccount = await googleSignIn.signIn();
    }
    state.googleUser = googleSignIn.currentUser;
    setState(() {
      state.isLoading = false;
      state.googleUser = googleSignIn.currentUser;
      state.loggedInVia = "Google";
    });
  }

  Future<Null> signOutOfGoogle() async {
    // Sign out from Firebase and Google
//    await FirebaseAuth.instance.signOut();
    await googleSignIn.signOut();
    // Clear variables
    googleAccount = null;
    state.googleUser = null;
    setState(() {
      state = StateModel(googleUser: null, loggedInVia: null);
    });
  }

  Future<Null> signInWithFacebook() async {
    FacebookLoginResult result;
    Map userProfile;
    if (facebookProfile == null) {
      result = await facebookLogin.logIn(['email']);
    }
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=$token');
        userProfile = JSON.jsonDecode(graphResponse.body);
        setState(() {
          state.isLoading = false;
          state.facebookUser = userProfile;
          state.loggedInVia = "Facebook";
        });
        break;
      case FacebookLoginStatus.cancelledByUser:
        setState(() {
          state.isLoading = false;
          state.facebookUser = null;
        });
        break;

      case FacebookLoginStatus.error:
        setState(() {
          state.isLoading = false;
          state.facebookUser = null;
        });
        break;
    }
  }

  Future<Null> signOutOfFacebook() async {
    facebookLogin.logOut();
    setState(() {
      state = StateModel(facebookUser: null, loggedInVia: null);
    });
  }

  signOut() async {
    switch (state.loggedInVia) {
      case "Google":
        await googleSignIn.signOut();
        // Clear variables
        googleAccount = null;
        state.googleUser = null;
        setState(() {
          state = StateModel(googleUser: null, loggedInVia: null);
        });
        break;
      case "Facebook":
        facebookLogin.logOut();
        setState(() {
          state = StateModel(facebookUser: null, loggedInVia: null);
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;

  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  // Rebuild the widgets that inherit from this widget
  // on every rebuild of _StateDataWidget:
  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}
