import 'package:flutter/material.dart';

class ThemeColor {
  final int? themeNumber;
  final BuildContext context;

  ThemeColor({this.themeNumber, required this.context});

  Brightness get _effectiveBrightness {
    switch (themeNumber) {
      case 1:
        return Brightness.light;
      case 2:
        return Brightness.dark;
      default:
        return Theme.of(context).brightness;
    }
  }

  bool get _isLight => _effectiveBrightness == Brightness.light;
  bool get isLight => _isLight;

  //main
  Color get mainBackColor => _isLight ? Color.fromRGBO(38,241,154,1) : Color.fromRGBO(14, 50, 35, 1.0);
  Color get mainForeColor => _isLight ? Colors.grey[100]! : Colors.grey[700]!;
  Color get colorHistoryLength => _isLight ? Colors.grey[100]! : Colors.grey[300]!;
  Color get colorAutoCompleteButton => _isLight ? Colors.yellow[800]! : Colors.yellow;
  Color get colorStepNumberOffFore => Color.fromARGB(255, 255,255,255);
  Color get colorStepNumberOffBack => Color.fromARGB(255, 41,125,88);
  Color get colorStepNumberOnFore => Color.fromARGB(255, 41,125,88);
  Color get colorStepNumberOnBack => Color.fromARGB(255, 255,255,0);
  //setting page
  Color get backColor => _isLight ? Colors.grey[300]! : Colors.grey[900]!;
  Color get cardColor => _isLight ? Colors.white : Colors.grey[800]!;
  Color get appBarForegroundColor => _isLight ? Colors.grey[700]! : Colors.white70;
  Color get dropdownColor => cardColor;
  Color get borderColor => _isLight ? Colors.grey[300]! : Colors.grey[700]!;
  Color get inputFillColor => _isLight ? Colors.grey[50]! : Colors.grey[900]!;
}
