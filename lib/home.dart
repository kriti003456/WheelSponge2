import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Stories.dart';
import 'login.dart';
import 'state.dart';
import 'state_widget.dart';

import 'package:geolocator/geolocator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel appState;
  String location;
  List<Story> storiesList = [];
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  Widget _buildStories({Widget body}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('WheelSponge'),
      ),
      drawer: _buildDrawer(),

      // body: Container(
      //   decoration: BoxDecoration(color: Colors.grey[400]),
      //   child: Center(
      //     child: StreamBuilder<QuerySnapshot>(
      //       stream: Firestore.instance.collection('UserStories').snapshots(),
      //       builder: (context, snapshot) {
      //         if (!snapshot.hasData)
      //           return LinearProgressIndicator();
      //         else {
      //           storiesList.clear();
      //           snapshot.data.documents.map((data) {
      //             print(data['storyName']);
      //             storiesList.add(new Story(
      //                 data['storyName'], data['writer'], data['description']));
      //             var record = Record.fromSnapshot(data);
      //             print(record);
      //           }).toList();
      //           print(storiesList.length);
      //           return StoryList(storiesList);
      //         }
      //      },
      //   )),
      // ),
    );
  }

  Widget _buildContent() {
    print(
        "App state from home.dart buildContent ${appState.loggedInVia} ${appState.isLoading}");
    if (appState.isLoading) {
      return _buildLoadingIndicator();
    } else if (!appState.isLoading &&
        appState.googleUser == null &&
        appState.facebookUser == null) {
      return new LoginScreen();
    } else {
      return _buildStories();
    }
  }

  Widget _buildDrawer() {
    _getCurrentLocation();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: appState.loggedInVia == "Google"
                ? (Text("Hello, ${appState.googleUser.displayName}"))
                : (Text("Hello, ${appState.facebookUser["name"]}")),
          ),
          ListTile(
            title: (location != null) ? Text("Location: $location") : Text("loading..."),
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
              StateWidget.of(context).signOut();
            },
          )
        ],
      ),
    );
  }

  Center _buildLoadingIndicator() {
    return Center(
      child: new CircularProgressIndicator(),
    );
  }

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
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    print(
        "App state from home.dart build ${appState.loggedInVia} ${appState.isLoading}");
    return _buildContent();
  }
}

class Record {
  final String description;
  final String storyName;
  final String writer;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['description'] != null),
        assert(map['storyName'] != null),
        assert(map['writer'] != null),
        description = map['description'],
        storyName = map['storyName'],
        writer = map['writer'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$description:$storyName:$writer>";
}
