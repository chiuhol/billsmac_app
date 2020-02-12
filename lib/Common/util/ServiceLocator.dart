import 'package:get_it/get_it.dart';
import 'package:billsmac_app/Common/util/TelAndSmsService.dart';

GetIt locator = GetIt();
void setupLocator() {
  locator.registerSingleton(TelAndSmsService());
}