import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/screens/alarm_home_screen.dart';
import 'package:tinnitus_smart_alarm/screens/settings_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/screens/stimuli_selection_screen.dart';
import 'package:tinnitus_smart_alarm/screens/tips_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const AlarmHomeScreen(),
    const StimuliSelectionScreen(),
    const TipsScreen(),
    const SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
