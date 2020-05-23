import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wheelsponge/Data/AppData.dart';
import 'package:wheelsponge/Pages/otpAuthPage.dart';
import 'package:wheelsponge/service_locator.dart';

import '../Models/UserData.dart';
import '../Services/signInService.dart';
import 'HomePage.dart';

class AddressForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  var _signInService = locator<SignInService>();
  AppData _appData = AppData();
  String cityDropDown = "Pune";
  List<String> areaDropDown = ["Punawale"];
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  UserData _data = new UserData();
  List tempList = List();
  Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

//  _buildView() {
//    if (_data.society == null) return _buildForm();
//    return _showData();
//  }

  Future<void> submit() async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();
      String _address = this._data.house +
          ", " +
          this._data.society +
          ", " +
          this._data.locality +
          ", " +
          this._data.landmark;
      await _firestore
          .collection('users')
          .document(_signInService.firebaseUser.uid)
          .setData({
        'city': this._data.city,
        'instructions': this._data.instructions,
        'address': _address
      });
      //TODO: test send data to database
    }
  }

  List<String> createAreaDropdown() {
    if (cityDropDown == "Pune") {
      return areaDropDown;
    }
    return _appData.jaipurAreaList;
  }

  Widget _buildForm() {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text('WheelSponge')),
//          padding: EdgeInsets.all(10),
      body: new Form(
        key: this._formKey,
        child: new ListView(
          children: <Widget>[
            DropdownButtonFormField(
              isExpanded: false,
              icon: Icon(Icons.arrow_drop_down),
              items: _appData.cityList.map((item) {
                return new DropdownMenuItem(
                  child: Text(item),
                  value: item,
                );
              }).toList(),
              onChanged: (selectedCity) {
                setState(() {
                  areaDropDown = null;
                  cityDropDown = selectedCity;
                  tempList = selectedCity == "Jaipur"
                      ? _appData.jaipurAreaList
                      : _appData.puneAreaList;
                  this._data.city = selectedCity;
                });
              },
              value: cityDropDown,
            ),
            DropdownButtonFormField(
              isExpanded: false,
              icon: Icon(Icons.arrow_drop_down),
              items: tempList.map((item) {
                return new DropdownMenuItem(
                  child: Text(item),
                  value: item,
                );
              }).toList(),
              onChanged: (selectedArea) {
                setState(() {
                  areaDropDown = selectedArea;
                  this._data.locality = selectedArea;
                });
              },
              value: areaDropDown,
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Flat No.',
                  labelText: 'House No./Flat No./Plot No.'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your house number';
                }
                return null;
              },
              onSaved: (String value) {
                this._data.house = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: '',
                labelText: 'Apartment/Residential Complex/Locality',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter your locality';
                }
                return null;
              },
              onSaved: (String value) {
                this._data.society = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(hintText: '', labelText: 'Landmark'),
              onSaved: (String value) {
                this._data.landmark = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'Model/number',
                  labelText: 'Vehicle Locating Instruction'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter instructions';
                }
                return null;
              },
              onSaved: (String value) {
                this._data.instructions = value;
              },
            ),
            RaisedButton(
              child: Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await submit();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OtpAuthPage()));
              },
              color: Colors.blue,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _showData() {
    return MaterialApp(
        home: Scaffold(
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text("City: ${_data.city}"),
            new Text("locality: ${_data.locality}"),
            new Text("house: ${_data.house}"),
            new Text("society: ${_data.society}"),
            new Text("landmark: ${_data.landmark}"),
            new Text("instructions: ${_data.instructions}"),
          ],
        ),
      ),
    ));
  }
}
