import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool? switchValue;
  double? volume = 0.3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: const Text('English'),
              tiles: [
                SettingsTile(
                  title: const Text('English'),
                  leading: const Icon(Icons.language),
                  onPressed: (BuildContext context) {},
                ),
              ],
            ),
            SettingsSection(
              title: const Text('Favorite Alarm Settings'),
              tiles: [
                SettingsTile.switchTile(
                  title: const Text('Loop alarm audio'),
                  leading: const Icon(Icons.loop),
                  initialValue: switchValue ?? true,
                  onToggle: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Vibrate'),
                  leading: const Icon(Icons.vibration),
                  initialValue: switchValue ?? true,
                  onToggle: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
                SettingsTile.switchTile(
                  title: const Text('Fade in'),
                  leading: const Icon(Icons.trending_up_rounded),
                  initialValue: switchValue ?? true,
                  onToggle: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
                SettingsTile.switchTile(
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Custom volume'),
                      switchValue ?? false
                          ? SizedBox(
                              height: 30,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    volume! > 0.7
                                        ? Icons.volume_up_rounded
                                        : volume! > 0.1
                                            ? Icons.volume_down_rounded
                                            : Icons.volume_mute_rounded,
                                  ),
                                  Expanded(
                                    child: Slider(
                                      value: volume!,
                                      onChanged: (value) {
                                        setState(() => volume = value);
                                      },
                                    ),
                                  ),
                                ],
                              ))
                          : const SizedBox(),
                    ],
                  ),
                  leading: const Icon(Icons.volume_up),
                  initialValue: switchValue ?? true,
                  onToggle: (bool value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                ),
              ],
            )
          ],
        ));
  }
}
