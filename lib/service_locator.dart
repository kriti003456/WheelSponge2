import 'package:get_it/get_it.dart';
import 'package:wheelsponge/Services/locationService.dart';
import 'package:wheelsponge/Services/signInService.dart';

final locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton<SignInService>(SignInService());
  locator.registerSingleton<LocationService>(LocationService());
}