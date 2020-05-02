import 'package:google_sign_in/google_sign_in.dart';

class StateModel {
  bool isLoading;
  GoogleSignInAccount googleUser;
  String loggedInVia;
  Map  facebookUser;

  StateModel({

    this.isLoading = false,
    this.googleUser,
    this.loggedInVia,
    this.facebookUser,
  });
}