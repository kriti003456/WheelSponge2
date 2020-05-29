import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wheelsponge/Services/signInService.dart';

import '../service_locator.dart';

class PackagesPage extends StatefulWidget {
  @override
  _PackagesPageState createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  final _signInService = locator<SignInService>();
  Firestore _firestore = Firestore.instance;
  String _city;
  QuerySnapshot _hatchbackPacks;
  QuerySnapshot _sedanPacks;
  QuerySnapshot _luxuryPacks;
  QuerySnapshot _suvPacks;


  @override
  initState(){
    super.initState();
    _getPackage();
  }

  _getUserCity() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .document(_signInService.firebaseUser.uid)
        .get();
    _city = snapshot.data["city"];
  }

  _getPackage() async {
    _getUserCity();
    _hatchbackPacks = await _firestore
        .collection('subpack')
        .where("city", isEqualTo: _city)
        .where("bodyType", isEqualTo: "Hatchback")
        .getDocuments();
    _sedanPacks = await _firestore
        .collection('subpack')
        .where("city", isEqualTo: _city)
        .where("bodyType", isEqualTo: "Sedan")
        .getDocuments();
    _suvPacks = await _firestore
        .collection('subpack')
        .where("city", isEqualTo: _city)
        .where("bodyType", isEqualTo: "SUV")
        .getDocuments();
    _luxuryPacks = await _firestore
        .collection('subpack')
        .where("city", isEqualTo: _city)
        .where("bodyType", isEqualTo: "Luxury")
        .getDocuments();
  }

  Widget _buildCard(QuerySnapshot packs) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      height: 220,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return _buildCard(_hatchbackPacks);
  }
}
