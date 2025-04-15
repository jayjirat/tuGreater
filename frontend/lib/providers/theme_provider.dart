import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData get lightTheme => AppThemes.lightTheme
      .copyWith(primaryColor: Color(0xFFE95C00), cardColor: Color(0xFFE95C00));
  ThemeData get darkTheme => AppThemes.darkTheme
      .copyWith(primaryColor: Colors.redAccent, cardColor: Color(0xFFE95C00));
  ThemeData get currentTheme =>
      _themeMode == ThemeMode.dark ? AppThemes.darkTheme : AppThemes.lightTheme;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
