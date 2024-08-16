// ignore_for_file: must_be_immutable, unused_element, library_private_types_in_public_api

import 'package:chat/constants/app_theme.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/services/navigation_service.dart';
import 'package:chat/utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
//import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:window_manager/window_manager.dart';
import 'firebase_options.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

class MyApp extends StatefulWidget {
  late NavigationService _navigationService;
  late AuthService _authService;

  MyApp({super.key, AdaptiveThemeMode? savedThemeMode}) {
    final GetIt getIt = GetIt.instance;
    _navigationService = getIt.get<NavigationService>();
    _authService = getIt.get<AuthService>();
  }

  // static void setlocale(Locale locale) async {
  //   _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
  //   var prefs = await SharedPreferences.getInstance();
  //   prefs.setString('languagecode', Locale.languageCode);

  //   state?.setState(() {
  //     state._locale = locale;
  //   });
  // }

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('tr');

  void _changeLanguage(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
  }

  Future<Locale> _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();

    String languageCode = prefs.getString('languageCode') ?? 'tr';

    return Locale(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme();

    return AdaptiveTheme(
      light: appTheme.lightTheme,
      dark: appTheme.darkTheme,
      initial: AdaptiveThemeMode.light,
      builder: (theme, darkTheme) => MaterialApp(
        navigatorKey: widget._navigationService.navigatorKey,
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme,
        darkTheme: darkTheme,
        locale: _locale,
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
        //uygulamaya giriş yaptığı an user ı çekmen gerekiyor
        initialRoute: widget._authService.user != null // neden null geliyor????
            ? "/home"
            : "/login",
        routes: widget._navigationService.routes,
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