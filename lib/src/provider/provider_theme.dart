import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Color accentColor = Colors.red;
  Color backgroundColor = Colors.white;
  Color secondaryColor = Colors.grey.shade50;
  Color textColor = Colors.grey.shade800;
  Color hintColor = Colors.grey.shade600;
  Color shadowColor = Colors.black12;
  Color errorColor = Colors.red.shade400;
  Color selectionColor = Colors.indigo.shade50;
  Color opacityUserIcon = Colors.red.shade50;
  Color opacityLogoutIcon = Colors.red.shade50;

  applyTheme(Color color) {
    accentColor = color;
    selectionColor = color.withOpacity(.05);
    notifyListeners();
  }
}
