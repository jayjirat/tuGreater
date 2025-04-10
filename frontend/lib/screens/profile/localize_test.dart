import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/locale_provider.dart';

class LocalizeTest extends StatelessWidget {
  const LocalizeTest({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Localization Test')),
      body: Column(
        children: <Widget>[
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
          const Text("Toggle Language"),
        ],
      ),
    );
  }
}
