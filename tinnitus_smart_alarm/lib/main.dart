import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/screens/alarm_home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tinnitus_smart_alarm/screens/main_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);

  Future<AdaptiveThemeMode?> getDarkModeSetting() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final darkModeSetting = prefs.getBool('darkMode');

    // Falls 'darkMode' in den Einstellungen gefunden wird, verwende diesen Wert
    if (darkModeSetting != null) {
      return darkModeSetting ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light;
    }

    // Speichere die Systemeinstellung als neuen Wert, wenn kein Wert vorhanden ist
    final systemIsDark =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .platformBrightness ==
            Brightness.dark;
    await prefs.setBool('darkMode', systemIsDark);

    return systemIsDark ? AdaptiveThemeMode.dark : AdaptiveThemeMode.light;
  }

  final savedThemeMode = await getDarkModeSetting();
  final initialThemeMode = savedThemeMode ?? AdaptiveThemeMode.system;

  runApp(
    AdaptiveTheme(
      light: ThemeData.light(
        useMaterial3: true,
      ),
      dark: ThemeData.dark(useMaterial3: true),
      initial: initialThemeMode,
      builder: (theme, darkTheme) => MaterialApp(
        theme: theme,
        darkTheme: darkTheme,
        home: const MainScreen(),
      ),
    ),
  );
}
