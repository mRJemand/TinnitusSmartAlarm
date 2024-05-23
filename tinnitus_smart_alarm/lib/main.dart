import 'dart:developer';
import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/screens/main_screen.dart';
import 'package:tinnitus_smart_alarm/l10n/l10n.dart';
import 'package:tinnitus_smart_alarm/services/auth_manager.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:tinnitus_smart_alarm/theme/color_schemes.g.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
      NotificationChannel(
        channelKey: 'scheduled',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      ),
    ],
  );

  SettingsManager settingsManager = SettingsManager();
  String? localeString = await settingsManager.getLocaleSetting();
  Locale locale;

  if (localeString != null) {
    locale = Locale(localeString);
  } else {
    Locale systemLocale = WidgetsBinding.instance.window.locale;
    log(systemLocale.languageCode);
    if (L10n.contains(systemLocale)) {
      locale = systemLocale;
      await settingsManager.setLocaleSetting(systemLocale.languageCode);
    } else {
      locale = const Locale('en');
      await settingsManager.setLocaleSetting('en');
    }
  }

  final savedThemeMode = await getDarkModeSetting();
  final initialThemeMode = savedThemeMode ?? AdaptiveThemeMode.system;

  AuthManager authService = AuthManager();
  await authService.checkAndSignInAnonymously();

  runApp(MyApp(locale: locale, initialThemeMode: initialThemeMode));
}

Future<AdaptiveThemeMode?> getDarkModeSetting() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final darkModeSetting = prefs.getBool('darkMode');

  if (darkModeSetting != null) {
    return darkModeSetting ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light;
  }

  final systemIsDark = MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .platformBrightness ==
      Brightness.dark;
  await prefs.setBool('darkMode', systemIsDark);
  return systemIsDark ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light;
}

class MyApp extends StatelessWidget {
  final Locale locale;
  final AdaptiveThemeMode initialThemeMode;

  MyApp({required this.locale, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.from(colorScheme: lightColorScheme, useMaterial3: true),
      dark: ThemeData.from(colorScheme: darkColorScheme, useMaterial3: true),
      initial: initialThemeMode,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        locale: locale,
        supportedLocales: L10n.all,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const MainScreen(),
        navigatorKey: GlobalNavigator.navigatorKey,
      ),
    );
  }
}

class GlobalNavigator {
  static final navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState? get currentState => navigatorKey.currentState;
}
