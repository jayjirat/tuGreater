import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  final String errorMessage;
  final bool fromLogin;
  const ErrorPage(
      {super.key, required this.errorMessage, this.fromLogin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔸 Mascot / Big Icon
                Icon(
                  Icons.sentiment_very_dissatisfied_outlined,
                  size: 120,
                  color: Theme.of(context).primaryColor,
                ),

                const SizedBox(height: 32),

                // 🔹 Static Title
                Text(
                  AppLocalizations.of(context)!.errorOops,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // 🔹 Dynamic error message
                Text(
                  errorMessage,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // 🔹 Button to go back
                ElevatedButton.icon(
                  onPressed: () {
                    if (fromLogin) {
                      Navigator.pushNamed(context, '/');
                    } else {
                      Navigator.pushNamed(context, '/community');
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).cardColor,
                  ),
                  label: Text(
                    AppLocalizations.of(context)!.goBack,
                    style: TextStyle(color: Theme.of(context).cardColor),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
