import 'package:geolocator/geolocator.dart';

class LocationService{

  String location;
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;

  getCurrentLocation(){
    geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
        _currentPosition = position;
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
        location = "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch(e){
      print(e);
    }
  }

}