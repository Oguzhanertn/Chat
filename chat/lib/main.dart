// ignore_for_file: must_be_immutable, unused_element

import 'package:chat/constants/app_theme.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/navigation_service.dart';
import 'package:chat/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//import 'package:intl/intl_browser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    size: Size(450, 700),
    minimumSize: Size(450, 700),
    backgroundColor: Colors.transparent,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  }); // widow manager

  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await setup();

  runApp(MyApp(savedThemeMode: savedThemeMode));
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late NavigationService _navigationService;
  late AuthService _authService;

  MyApp({super.key, AdaptiveThemeMode? savedThemeMode}) {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();

    return AdaptiveTheme(
      light: appTheme.lightTheme,
      dark: appTheme.darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        navigatorKey: _navigationService.navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        locale: const Locale("tr"),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('tr'),
        ],
        initialRoute: _authService.user != null ? "/home" : "/login",
        routes: _navigationService.routes,
      ),
    );
  }
}


//TODO:
// Drawer eklenmeli
// Drawer da home sayfası, Settings, çıkış 
// Tema seçeneği eklenmeli( Settings sayfasında) //Localization sana bırakıyorum
// Mesajlar silinebilmeli
// Mesajlar listesinde isim altında son mesaj görüntülensin
// Floating Button eklenmeli basınca Kime mesajı şeklinde gösterilmeli Kişler listelenmeli 