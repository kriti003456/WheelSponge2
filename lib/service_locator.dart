import 'package:get_it/get_it.dart';
import 'package:wheelsponge/Services/locationService.dart';
import 'package:wheelsponge/Services/signInService.dart';
GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(SignInService());
  locator.registerSingleton(LocationService());
}