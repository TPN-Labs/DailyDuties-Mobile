import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dailyduties/config/constants.dart';
import 'package:dailyduties/config/textstyle.dart';
import 'package:dailyduties/view/home/home_screen.dart';
import 'package:dailyduties/view/welcome_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (_) => runApp(
      const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static setColorTheme(BuildContext context, ThemeMode colorScheme) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setColorTheme(colorScheme);
  }

  static setLocale(BuildContext context, Locale locale) async {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
    Get.updateLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
  final bool _isUserLoggedIn = FirebaseAuth.instance.currentUser != null;

  ThemeMode _colorScheme = ThemeMode.system;

  late Locale _appLocale = getLanguageFromStorage().locale;

  ThemeMode getThemeFromStorage() {
    var storageThemeMode = GetStorage().read(StorageKeys.appThemeMode);
    if (storageThemeMode == null) return ThemeMode.system;
    return ThemeMode.values.byName(storageThemeMode.toString().replaceFirst('ThemeMode.', ''));
  }

  ThemeData getThemeMode() {
    ThemeMode currentThemeMode = getThemeFromStorage();
    if (currentThemeMode == ThemeMode.light) {
      return AppTheme.lightTheme();
    } else if (currentThemeMode == ThemeMode.dark) {
      return AppTheme.darkTheme();
    } else {
      return (SchedulerBinding.instance.window.platformBrightness == Brightness.dark ? AppTheme.darkTheme() : AppTheme.lightTheme());
    }
  }

  setColorTheme(ThemeMode schemeMode) {
    if (schemeMode == ThemeMode.system) {
      var deviceColorScheme = SchedulerBinding.instance.window.platformBrightness;
      setState(() {
        AppTheme.isLightTheme = deviceColorScheme == Brightness.dark;
      });
    } else if (schemeMode == ThemeMode.dark) {
      setState(() {
        AppTheme.isLightTheme = false;
      });
    } else if (schemeMode == ThemeMode.light) {
      setState(() {
        AppTheme.isLightTheme = true;
      });
    }
    _colorScheme = schemeMode;
    GetStorage().write(StorageKeys.appThemeMode, _colorScheme.toString());
  }

  AppLanguage getLanguageFromStorage() {
    var storageLanguage = GetStorage().read(StorageKeys.appLanguage);
    if (storageLanguage == null) return AppLanguage.system;
    return AppLanguage.values.byName(storageLanguage.toString().replaceFirst('AppLanguage.', ''));
  }

  setLocale(Locale value) {
    setState(() {
      _appLocale = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Duties',
      debugShowCheckedModeBanner: false,
      theme: getThemeMode(),
      home: _isUserLoggedIn ? const HomeScreen() : const WelcomeScreen(),
      locale: _appLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        AppLanguage.english.locale, // English
        AppLanguage.romanian.locale // Romanian
      ],
    );
  }
}
