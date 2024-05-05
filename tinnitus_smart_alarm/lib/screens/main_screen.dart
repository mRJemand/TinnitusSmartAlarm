import 'dart:developer';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tinnitus_smart_alarm/screens/alarm_home_screen.dart';
import 'package:tinnitus_smart_alarm/screens/onboarding_screen.dart';
import 'package:tinnitus_smart_alarm/screens/privacy_consent_screen.dart';
import 'package:tinnitus_smart_alarm/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/screens/stimuli_selection_screen.dart';
import 'package:tinnitus_smart_alarm/screens/tips_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:tinnitus_smart_alarm/widgets/tinnitus_survey.dart';
import 'package:tinnitus_smart_alarm/main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _hasSeenOnboarding = false;
  bool? _hasConsented = null;
  SettingsManager settingsManager = SettingsManager();

  final List<Widget> _screens = [
    const AlarmHomeScreen(),
    const StimuliSelectionScreen(),
    const TipsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _requestNotificationsPermissions();

    // Benachrichtigungsaktionen registrieren
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceived,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _loadPreferences() async {
    _hasSeenOnboarding =
        await settingsManager.getHasSeenOnboardingSetting() ?? false;
    _hasConsented = await settingsManager.getAllowDataCollectionSetting();
    setState(() {});
    _removeSplashScreen();
  }

  void _removeSplashScreen() {
    FlutterNativeSplash.remove();
  }

  Future<void> _requestNotificationsPermissions() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }
  }

  void _scheduleNotification() {
    Future.delayed(const Duration(seconds: 4), () {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Alarm Notification',
          body: 'This is a notification from the Floating Action Button',
          notificationLayout: NotificationLayout.Default,
          payload: {'uuid': 'uuid-test'},
        ),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_SURVEY',
            label: 'Open Survey',
          ),
        ],
      );
    });
  }

  Future<void> _showSurvey(Map<String, String?>? payload) async {
    log('Notification Payload: $payload');
    await showDialog<void>(
      context: GlobalNavigator.navigatorKey.currentState!.context,
      builder: (BuildContext context) {
        return Dialog(
          child: TinnitusSurvey(),
        );
      },
    );
  }

  Future<void> _onActionReceived(ReceivedAction receivedAction) async {
    // if (receivedAction.buttonKeyPressed == 'OPEN_SURVEY') {
    await _showSurvey(receivedAction.payload);
    // }
  }

  Widget _buildApp(Widget homeScreen) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: homeScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasSeenOnboarding) {
      return _buildApp(
        OnboardingScreen(
          onComplete: () async {
            await settingsManager.setHasSeenOnboardingSetting(true);
            setState(() {
              _hasSeenOnboarding = true;
            });
          },
        ),
      );
    } else if (_hasConsented == null) {
      return _buildApp(
        PrivacyConsentScreen(
          onConsent: (bool consented) async {
            await settingsManager.setAllowDataCollectionSetting(consented);
            setState(() {
              _hasConsented = true;
              log('_hasConsented: $consented');
            });
          },
        ),
      );
    } else {
      return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Icons.alarm),
              label: AppLocalizations.of(context)!.alarm,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.play_circle_outline),
              label: AppLocalizations.of(context)!.stimuli,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.tips_and_updates_outlined),
              label: AppLocalizations.of(context)!.tips,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: AppLocalizations.of(context)!.settings,
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scheduleNotification,
          child: const Icon(Icons.notifications),
        ),
      );
    }
  }
}
