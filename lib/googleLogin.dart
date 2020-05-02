import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginFunctionality{
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Future<GoogleSignInAccount> _loginWithGoogle() async {
    GoogleSignInAccount account;
    try {
        account = await _googleSignIn.signIn();
      } catch (err) {
      print("------login failed");
      print(err);
    }
    return account;
  }

  _logoutGoogle() {
    _googleSignIn.signOut();

  }
}