import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/screens/chart_screen.dart';
import 'package:tinnitus_smart_alarm/services/auth_manager.dart';
import 'package:tinnitus_smart_alarm/services/firestore_manager.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/widgets/survey_data_chart.dart';
import 'package:tinnitus_smart_alarm/widgets/tinnitus_survey.dart';
import 'package:tinnitus_smart_alarm/widgets/volume_slider.dart';

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
  bool allowDataCollecting = false;

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
    allowDataCollecting = await settingsManager.getAllowDataCollectionSetting();
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
                leading: const Icon(Icons.music_note_outlined),
                trailing: SizedBox(
                  width: 150,
                  child: Text(
                    assetAudio,
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.clip,
                    maxLines: 4,
                  ),
                ),
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
                description: VolumeSlider(
                  initialVolume: volume ?? 0.5,
                  onChanged: (newVolume) {
                    if (volume != newVolume) {
                      setState(() => volume = newVolume);
                      settingsManager.setVolumeSetting(newVolume);
                    }
                  },
                ),
              ),
            ],
          ),
          SettingsSection(
            title: Text(AppLocalizations.of(context)!.personal),
            tiles: [
              SettingsTile(
                enabled: allowDataCollecting ?? false,
                title: Text(AppLocalizations.of(context)!.addRecord),
                leading: const Icon(Icons.add_chart_outlined),
                onPressed: (context) => _showSurvey(),
              ),
              SettingsTile.navigation(
                enabled: allowDataCollecting ?? false,
                title: Text(AppLocalizations.of(context)!.history),
                leading: const Icon(Icons.ssid_chart_outlined),
                onPressed: (context) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ChartScreen(),
                    ),
                  );
                },
              ),
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.allowDataCollecting),
                leading: const Icon(Icons.analytics_outlined),
                trailing: IconButton(
                    onPressed: () {
                      _showDataCollectInfo();
                    },
                    icon: const Icon(Icons.info_outline)),
                initialValue: allowDataCollecting,
                onToggle: (bool value) {
                  if (value == false) {
                    _showConfirmationDialog(context, value);
                  } else {
                    setState(() {
                      allowDataCollecting = value;
                    });
                    settingsManager.setAllowDataCollectionSetting(value);
                  }
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.deleteData),
                leading: const Icon(Icons.delete_outlined),
                onPressed: (context) async {
                  _showDataDeletionConfirmationDialog(context);
                  // FirestoreManager firestoreManager = FirestoreManager();
                  // AuthManager authManager = AuthManager();

                  // await firestoreManager.deleteCurrentUserEntries();
                  // await authManager.signOutAndDeleteAccount();
                },
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: Row(
      //   children: [
      //     FloatingActionButton(
      //       heroTag: "a",
      //       onPressed: () => printSharedPreferences(),
      //     ),
      //     FloatingActionButton(
      //       heroTag: "b",
      //       onPressed: () => clearSharedPreferences(),
      //       backgroundColor: Colors.red,
      //     ),
      //   ],
      // ),
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
    print('Shared Preferences:');
    prefs.getKeys().forEach((key) {
      prefs.remove(key);
    });
  }

  Future<void> _showSurvey() async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: TinnitusSurvey(),
        );
      },
    );
  }

  Future<void> _showDataCollectInfo() async {
    final double maxHeight = MediaQuery.of(context).size.height * 0.8;
    await showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight,
          ),
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dataProtextionNotice,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8.0),
                    Text(AppLocalizations.of(context)!.dataPrivacyText),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, bool newValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmationRequired),
          content: Text(AppLocalizations.of(context)!.confirmationText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  allowDataCollecting = newValue;
                });
                settingsManager.setAllowDataCollectionSetting(newValue);
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  void _showDataDeletionConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmationRequired),
          content:
              Text(AppLocalizations.of(context)!.confirmationDeleteDataText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () async {
                FirestoreManager firestoreManager = FirestoreManager();
                AuthManager authManager = AuthManager();

                await firestoreManager.deleteCurrentUserEntries();
                await authManager.signOutAndDeleteAccount();
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }
}
