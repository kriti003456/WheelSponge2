
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wheelsponge/service_locator.dart';

import 'Pages/LandingPage.dart';
import 'Pages/signinPage.dart';

void main(){
//  StateWidget stateWidget = new StateWidget(child:new MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(new LandingPage());
}
