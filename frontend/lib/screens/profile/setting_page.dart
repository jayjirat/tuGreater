import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/locale_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;

class SettingPage extends rp.ConsumerStatefulWidget {
  const SettingPage({super.key});

  @override
  rp.ConsumerState<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends rp.ConsumerState<SettingPage> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final localeProvider = context.watch<LocaleProvider>();
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(10),
                  width: 350,
                  height: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.network(
                        user?.profileImageUrl ??
                            'https://default-placeholder-url.com/image.png',
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: Icon(Icons.person,
                                size: 50, color: Colors.grey[600]),
                          );
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.displayName ?? "NO DATA",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                          Text(
                            user?.studentId ?? "NO DATA",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            // Language Selection
            Text(
              "Language",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Text(AppLocalizations.of(context)!
                .helloWorld), // Text based on localization
            Switch(
              value: localeProvider.locale.languageCode ==
                  'th', // Check if the current language is Thai
              onChanged: (_) {
                localeProvider
                    .toggleLanguage(); // Toggle language using the provider
              },
            ),
            // Theme Selection
            Text(
              "Theme",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Switch(
                value: themeProvider.isDarkMode,
                onChanged: (_) {
                  themeProvider.toggleTheme();
                },
                activeColor: Theme.of(context).colorScheme.secondary,
                activeTrackColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                inactiveThumbColor: Theme.of(context).colorScheme.primary,
                inactiveTrackColor:
                    Theme.of(context).colorScheme.primaryContainer),
          ],
        ),
      ),
    );
  }
}
