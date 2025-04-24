import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/pages/admin.dart';
import 'package:frontend/screens/main.dart';
import 'package:frontend/screens/shop/shop.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend/dpname.dart';
import 'package:frontend/login.dart';
// import 'package:TUGREATER/lib/login.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/providers/locale_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:provider/provider.dart' as pd;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    ProviderScope(
      child: pd.MultiProvider(
        providers: [
          pd.ChangeNotifierProvider(create: (_) => ThemeProvider()),
          pd.ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = pd.Provider.of<ThemeProvider>(context);
    final localeProvider = pd.Provider.of<LocaleProvider>(context);

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en'),
          Locale('th'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: localeProvider.locale, // Get locale from provider
        themeMode: themeProvider.themeMode,
        theme: themeProvider.lightTheme,
        darkTheme: themeProvider.darkTheme,
        title: 'Flutter Demo',
        initialRoute: '/admin',
        routes: {
          '/': (context) => Login(),
          '/set-display-name': (context) => ConfirmationPage(),
          '/community': (context) => Main(),
          '/shop': (context) => Shop(),
          '/admin': (context) => AdminPage(),
        });
  }
}
