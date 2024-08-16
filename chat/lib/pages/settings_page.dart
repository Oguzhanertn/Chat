import 'package:adaptive_theme/adaptive_theme.dart';
//import 'package:chat/main.dart';
import 'package:country_flags/country_flags.dart';
import 'package:flutter/material.dart';
import 'package:chat/services/navigation_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  //late final Function(Locale) setLocale;
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;

  @override
  void initState() {
    _navigationService = _getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
        leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              _navigationService.pushReplacementNamed("/home");
            }),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 150,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  //MyApp.setLocale(context, const Locale("tr"));
                  //setLocale(Locale('en'));
                  //Navigator.pop(context);
                  //_changeLanguage(Locale('tr'));
                  //widget.changeLanguage(const Locale('tr'));
                },
                icon: CountryFlag.fromCountryCode(
                  'tr',
                  shape: const Circle(),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  //MyApp.setLocale(context, const Locale("en"));
                  //Navigator.pop(context);
                  //_changeLanguage(Locale('en'));
                  //widget.changeLanguage(const Locale('en'));
                },
                icon: CountryFlag.fromCountryCode(
                  'gb',
                  shape: const Circle(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  AdaptiveTheme.of(context).setLight();
                },
                icon: const Icon(Icons.light_mode),
                iconSize: 40,
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  AdaptiveTheme.of(context).setDark();
                },
                icon: const Icon(Icons.dark_mode),
                iconSize: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
