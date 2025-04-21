import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/locale_provider.dart';
import 'package:frontend/providers/theme_provider.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as rp;
import 'package:flutter_svg/flutter_svg.dart';

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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
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
                    color: Theme.of(context).secondaryHeaderColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.all(10),
                  width: 350,
                  height: 250,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        useOldImageOnUrlChange: true,
                        fadeInDuration: Duration.zero,
                        imageUrl: user?.profileImageUrl ??
                            'https://default-placeholder-url.com/image.png',
                        width: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => SizedBox(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.displayName ?? "NO DATA",
                            style: TextStyle(fontSize: 20),
                          ),
                          Text(
                            user?.studentId ?? "NO DATA",
                            style: TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
            // Language Selection
            Text(
              AppLocalizations.of(context)!.language,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/en.svg',
                  width: 25,
                  height: 25,
                  placeholderBuilder: (context) =>
                      const CircularProgressIndicator(),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppLocalizations.of(context)!.english,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Switch(
                    value: localeProvider.locale.languageCode == 'th',
                    onChanged: (_) {
                      localeProvider.toggleLanguage();
                    },
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.thai,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/svg/th.svg', // Thailand 🇹🇭
                  width: 28,
                  height: 28,
                  placeholderBuilder: (context) =>
                      const CircularProgressIndicator(),
                )
              ],
            ),

            // Theme Selection
            Text(
              AppLocalizations.of(context)!.theme,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svg/sun.svg',
                  width: 50,
                  height: 50,
                  colorFilter: ColorFilter.mode(Colors.orange, BlendMode.srcIn),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      AppLocalizations.of(context)!.lightmode,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (_) {
                      themeProvider.toggleTheme();
                    },
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.darkmode,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  'assets/svg/moon.svg',
                  width: 50,
                  height: 50,
                  colorFilter: ColorFilter.mode(
                      const Color.fromARGB(255, 255, 195, 67), BlendMode.srcIn),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
