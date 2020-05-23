import 'package:flutter/material.dart';
import 'package:wheelsponge/Services/signInService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

// ignore: must_be_immutable
class AppDrawer extends StatefulWidget {

  @override
  _AppDrawerState createState() => _AppDrawerState();

}

class _AppDrawerState extends State<AppDrawer>{

  String location;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  _getCurrentLocation(){

    geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
      _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async{
    try{
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude
      );

      Placemark place = p[0];
      setState(() {
        location = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAuth _auth = Provider.of<FirebaseAuth>(context);
    SignInService signInService = SignInService();
    _getCurrentLocation();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(),
          ListTile(
            title: (location != null)
                ? Text("Location: $location")
                : Text("loading..."),
          ),
          ListTile(
            title: Text("Profile"),
          ),
          ListTile(
            title: Text("Active Subscription"),
          ),
          ListTile(
            title: Text("Order History"),
          ),
          ListTile(
            title: Text("Customer Support"),
          ),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              Navigator.pop(context);
              signInService.signOut();
            },
          )
        ],
      ),
    );
  }
}