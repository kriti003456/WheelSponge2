import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wheelsponge/Services/signInService.dart';

import '../service_locator.dart';
import 'HomePage.dart';

class OtpAuthPage extends StatefulWidget {
  @override
  _OtpAuthPageState createState() => _OtpAuthPageState();
}

class _OtpAuthPageState extends State<OtpAuthPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  FirebaseUser _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;
  var _userService = locator<SignInService>();

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
  }

  _getFirebaseUser() {
    this._firebaseUser = _userService.firebaseUser;
    setState(() {
      _status =
          (_firebaseUser == null) ? "Not logged in\n" : "Already logged in\n";
    });
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;
        print(_firebaseUser.toString());
      });
      setState(() {
        _status += 'Signed In\n';
      });
    } catch (e) {
      setState(() {
        _status += e.toString() + '\n';
      });
      print(e.toString());
    }
  }

  Future<void> _submitPhoneNumber() async {
    String phoneNumber = "+91 " + _phoneNumberController.text.toString().trim();
    print(phoneNumber);

    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verification completed');
      setState(() {
        _status +=
            'verification completed \n ${_firebaseUser.displayName} ${_firebaseUser.phoneNumber}\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(AuthException error) {
      print('verification failed');
      setState(() {
        _status += 'verification failed\n';
      });
      print(error.message);
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }

    void codeSent(String verificationId, [int code]) {
      print('code sent');
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
      setState(() {
        _status += 'code sent\n';
      });
      this._otpController.text = code.toString();
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      this._verificationId = verificationId;
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(milliseconds: 10000),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _submitOtp() {
    String smsCode = _otpController.text.toString().trim();

    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode);
    _login();
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _firebaseUser = null;
      setState(() {
        _status += 'Signed out\n';
      });
    } catch (e) {
      setState(() {
        _status += e.toString() + '\n';
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('Wheelsponge'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          SizedBox(
            height: 24,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                      hintText: 'Phone Number', border: OutlineInputBorder()),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 1,
                child: MaterialButton(
                  onPressed: _submitPhoneNumber,
                  child: Text('Submit'),
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 48,
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _otpController,
                  decoration: InputDecoration(
                    hintText: 'OTP',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Spacer(),
              Expanded(
                flex: 1,
                child: MaterialButton(
                  onPressed: _submitOtp,
                  child: Text('Submit'),
                  color: Theme.of(context).accentColor,
                ),
              )
            ],
          ),
          SizedBox(
            height: 48,
          ),
          Text('$_status'),
        ],
      ),
    ));
  }
}
