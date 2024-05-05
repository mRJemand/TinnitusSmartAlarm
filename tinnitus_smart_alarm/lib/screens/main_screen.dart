import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/screens/alarm_home_screen.dart';
import 'package:tinnitus_smart_alarm/screens/onboarding_screen.dart';
import 'package:tinnitus_smart_alarm/screens/privacy_consent_screen.dart';
import 'package:tinnitus_smart_alarm/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/screens/stimuli_selection_screen.dart';
import 'package:tinnitus_smart_alarm/screens/tips_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _hasSeenOnboarding = false;
  bool _hasConsented = false;
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
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _setMyDataOK(bool value) async {
    settingsManager.setAllowDataCollectionSetting(value);
    setState(() {
      _hasConsented = value;
    });
  }

  Future<void> _loadPreferences() async {
    _hasSeenOnboarding =
        await settingsManager.getHasSeenOnboardingSetting() ?? false;
    _hasConsented =
        await settingsManager.getAllowDataCollectionSetting() ?? false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasSeenOnboarding) {
      return MaterialApp(
        home: OnboardingScreen(
          onComplete: () async {
            settingsManager.setHasSeenOnboardingSetting(true);
            setState(() {
              _hasSeenOnboarding = true;
            });
          },
        ),
      );
    } else if (!_hasConsented) {
      return MaterialApp(
        home: PrivacyConsentScreen(
          onConsent: (bool consented) {
            _setMyDataOK(consented);
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
      );
    }
  }
}
