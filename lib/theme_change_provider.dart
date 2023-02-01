import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier{

  var _themeMode = ThemeMode.light;
  ThemeMode get thememode => _themeMode;

  bool _enabled = true;
  bool get enabled => _enabled;

  void setTheme(thememode){
    _themeMode = thememode;
    notifyListeners();
  }

void setenable(bool enable){
_enabled = enable;
notifyListeners();
}
}