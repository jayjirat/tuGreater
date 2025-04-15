import 'package:flutter/material.dart';
import 'package:frontend/app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeData get lightTheme => AppThemes.lightTheme.copyWith(
      primaryColor: Color(0xFFE95C00),
      cardColor: Colors.white,
      canvasColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFE95C00),
        elevation: 2,
      ),
      textTheme: AppThemes.lightTheme.textTheme.copyWith(
        bodySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Color(0xFFF4F4F4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ));

  ThemeData get darkTheme => AppThemes.darkTheme.copyWith(
      primaryColor: Color(0xFFE95C00),
      cardColor: Color(0xFF2A2A2A),
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Color(0xFF1C1C1C),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFE95C00),
        elevation: 2,
      ),
      textTheme: AppThemes.darkTheme.textTheme.copyWith(
        bodySmall: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Color(0xFF444444),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
      ));
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
