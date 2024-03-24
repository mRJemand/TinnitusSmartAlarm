import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:flutter/services.dart';
import 'package:tinnitus_smart_alarm/screens/alarm_home_screen.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tinnitus_smart_alarm/screens/main_screen.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Alarm.init(showDebugLogs: true);

  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: const MainScreen(),
    ),
  );
}
