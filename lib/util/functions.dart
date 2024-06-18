import 'dart:ui';

import 'package:sgela_services/sgela_util/dark_light_control.dart';
import 'package:sgela_services/sgela_util/prefs.dart';

bool isDarkMode(Prefs prefs, Brightness brightness) {
  var mode = prefs.getMode();
  if (mode == DARK) {
    return true;
  }
  if (mode == LIGHT) {
    return false;
  }
  if (brightness == Brightness.dark) {
    return true;
  } else {
    return false;
  }
}
