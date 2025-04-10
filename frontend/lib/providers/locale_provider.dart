import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('en'); // Default to English

  Locale get locale => _locale;

  void toggleLanguage() {
    print(_locale.languageCode);
    _locale = (_locale.languageCode == 'en' ? Locale('th') : Locale('en'));
    notifyListeners(); // Notify listeners to rebuild the UI
  }
}
