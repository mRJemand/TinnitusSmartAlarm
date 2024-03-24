import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tinnitus_smart_alarm/services/settings_servics.dart';

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('General'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
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
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                onPressed: (BuildContext context) {},
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Alarm Settings'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Loop alarm audio'),
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
                title: const Text('Vibrate'),
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
                title: const Text('Fade in'),
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
                title: const Text('Custom volume'),
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
