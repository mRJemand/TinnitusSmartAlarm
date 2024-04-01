import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:restart_app/restart_app.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_servics.dart';
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
  String sound = "";

  final SettingsService settingsService = SettingsService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    darkMode = await settingsService.getDarkModeSetting();
    loopAlarmAudio = await settingsService.getLoopAudioSetting();
    vibrate = await settingsService.getVibrateSetting();
    fadeIn = await settingsService.getFadeInSetting();
    volume = await settingsService.getVolumeSetting();
    customVolume = await settingsService.getCustomVolumeSetting();
    sound = await settingsService.getAssetAudioSetting();
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
                  settingsService.setLocaleSetting('en');
                  _reloadApp();
                },
              ),
              ListTile(
                title: Text(AppLocalizations.of(context)!.german),
                onTap: () {
                  Navigator.of(context).pop();
                  settingsService.setLocaleSetting('de');
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

  @override
  Widget build(BuildContext context) {
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
                  settingsService.setDarkModeSetting(value);
                },
              ),
              SettingsTile(
                title: Text(AppLocalizations.of(context)!.language),
                description:
                    Text(AppLocalizations.of(context)!.selectedLanguage),
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
                  settingsService.setLoopAudioSetting(value);
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
                  settingsService.setVibrateSetting(value);
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
                  settingsService.setFadeInSetting(value);
                },
              ),
              SettingsTile.switchTile(
                title: Text(AppLocalizations.of(context)!.customVolume),
                leading: const Icon(Icons.volume_up),
                initialValue: customVolume,
                onToggle: (bool value) {
                  setState(() {
                    customVolume = value;
                  });
                  settingsService.setCustomVolumeSetting(value);
                },
                description: Slider(
                  value: volume,
                  min: 0.0,
                  max: 1.0,
                  divisions: 100,
                  onChanged: customVolume
                      ? (value) {
                          setState(() => volume = value);
                          settingsService.setVolumeSetting(value);
                        }
                      : null,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
