import 'dart:async';
import 'dart:convert' as JSON;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class SignInService {
  GoogleSignInAccount googleAccount;
  Map facebookProfile;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final facebookLogin = FacebookLogin();
  FirebaseUser firebaseUser;
  FirebaseAuth _auth;
  Firestore _firestore = Firestore.instance;

  Future<FirebaseUser> signInWithGoogle() async {
    if (googleAccount == null) {
      googleAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final AuthResult authResult =
          await _auth.signInWithCredential(credential);
      firebaseUser = authResult.user;

      assert(!firebaseUser.isAnonymous);
      assert(await firebaseUser.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      assert(firebaseUser.uid == currentUser.uid);
      print("Google signed in ${firebaseUser.displayName}");
    }
    return firebaseUser;
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
        print(userProfile);
        FacebookAccessToken facebookAccessToken = result.accessToken;
        final AuthCredential credential = FacebookAuthProvider.getCredential(
            accessToken: facebookAccessToken.token);
        final AuthResult authResult =
            await _auth.signInWithCredential(credential);
        firebaseUser = authResult.user;
        assert(firebaseUser.displayName != null);
        assert(!firebaseUser.isAnonymous);
        assert(await firebaseUser.getIdToken() != null);
        FirebaseUser currentUser = await _auth.currentUser();
        assert(firebaseUser.uid == currentUser.uid);
        break;
      case FacebookLoginStatus.cancelledByUser:
        break;

      case FacebookLoginStatus.error:
        break;
    }
  }

  signOut() async {
    if (googleAccount != null) {
      await googleSignIn.signOut();
      // Clear variables
      googleAccount = null;
    } else if (facebookProfile != null) {
      facebookLogin.logOut();
    }
    _auth.signOut();
  }

  checkNewUser() async {
    print("Checking for user");
    DocumentSnapshot snapshot =
        await _firestore.collection('users').document(firebaseUser.uid).get();
    if (snapshot.data.containsKey('city') == false) {
      await _firestore
          .collection('users')
          .document(firebaseUser.uid)
          .setData({'name': firebaseUser.displayName});
      return true;
    } else {
      return false;
    }
  }
}
