import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/auth_manager.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = true;
  bool loopAlarmAudio = true;
  bool vibrate = true;
  bool fadeIn = true;
  double volume = 0.3;
  bool customVolume = true;
  String assetAudio = "";
  int snoozeTime = 1;

  final SettingsManager settingsManager = SettingsManager();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    darkMode = await settingsManager.getDarkModeSetting();
    loopAlarmAudio = await settingsManager.getLoopAudioSetting();
    vibrate = await settingsManager.getVibrateSetting();
    fadeIn = await settingsManager.getFadeInSetting();
    volume = await settingsManager.getVolumeSetting();
    customVolume = await settingsManager.getCustomVolumeSetting();
    assetAudio = await settingsManager.getAssetAudioSetting();
    snoozeTime = await settingsManager.getSnoozeTimeSetting();
    setState(() {});
  }

  void _changeLanguage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                title: Text(AppLocalizations.of(context)!.english),
                onTap: () {
                  Navigator.of(context).pop();
                  settingsManager.setLocaleSetting('en');
                  _reloadApp();
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.german),
                onTap: () {
                  Navigator.of(context).pop();
                  settingsManager.setLocaleSetting('de');
                  _reloadApp();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _reloadApp() {
    Restart.restartApp();
  }

  void _setSnoozeTime() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _textFieldController =
            TextEditingController();
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.setSnoozeTime),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.enterSnoozeTime),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.ok),
              onPressed: () {
                int value = int.tryParse(_textFieldController.text) ??
                    1; // Standardwert oder Validierung erforderlich
                settingsManager.setSnoozeTimeSetting(value);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.general),
            tiles: [
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.darkMode),
                leading: const Icon(Icons.dark_mode),
                initialValue: darkMode,
                onToggle: (bool value) {
                  setState(() {
                    darkMode = value;
                  });
                  darkMode
                      ? AdaptiveTheme.of(context).setDark()
                      : AdaptiveTheme.of(context).setLight();
                  settingsManager.setDarkModeSetting(value);
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: Text(AppLocalizations.of(context)!.selectedLanguage),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {
                  _changeLanguage();
                },
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.alarmSettings),
            tiles: [
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.loopAlarmAudio),
                leading: const Icon(Icons.loop),
                initialValue: loopAlarmAudio,
                onToggle: (bool value) {
                  setState(() {
                    loopAlarmAudio = value;
                  });
                  settingsManager.setLoopAudioSetting(value);
                },
              ),
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.vibrate),
                leading: const Icon(Icons.vibration),
                initialValue: vibrate,
                onToggle: (bool value) {
                  setState(() {
                    vibrate = value;
                  });
                  settingsManager.setVibrateSetting(value);
                },
              ),
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.fadeIn),
                leading: const Icon(Icons.trending_up_rounded),
                initialValue: fadeIn,
                onToggle: (bool value) {
                  setState(() {
                    fadeIn = value;
                  });
                  settingsManager.setFadeInSetting(value);
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.snooze),
                leading: const Icon(Icons.snooze),
                trailing: Text(
                    '${snoozeTime.toString()} ${AppLocalizations.of(context)!.minutes}'),
                onPressed: (BuildContext context) {
                  _setSnoozeTime();
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.sound),
                trailing: Text(assetAudio),
              ),
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.customVolume),
                leading: const Icon(Icons.volume_up),
                initialValue: customVolume,
                onToggle: (bool value) {
                  setState(() {
                    customVolume = value;
                  });
                  settingsManager.setCustomVolumeSetting(value);
                },
                description: Slider(
                  value: volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChanged: customVolume
                      ? (value) {
                          setState(() => volume = value);
                          settingsManager.setVolumeSetting(value);
                        }
                      : null,
                ),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.personal),
            tiles: [
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.deleteData),
                leading: const Icon(Icons.delete_outlined),
                onPressed: (context) {
                  AuthManager authManager = AuthManager();
                  authManager.signOutAndDeleteAccount();
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.language),
                trailing: Text(AppLocalizations.of(context)!.selectedLanguage),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {
                  _changeLanguage();
                },
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton(
            onPressed: () => printSharedPreferences(),
          ),
          FloatingActionButton(
            onPressed: () => clearSharedPreferences(),
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Future<void> printSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Druckt alle Schlüssel-Werte-Paare
    log('Shared Preferences:');
    prefs.getKeys().forEach((key) {
      log('$key: ${prefs.get(key)}');
    });
  }

  Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // Druckt alle Schlüssel-Werte-Paare
    print('Shared Preferences:');
    prefs.getKeys().forEach((key) {
      // print('$key: ${prefs.get(key)}');
      prefs.remove(key);
    });
  }
}
