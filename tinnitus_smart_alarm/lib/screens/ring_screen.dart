import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmRingScreen extends StatelessWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              AppLocalizations.of(context)!.yourAlarmIsRinging,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text("🔔", style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.snooze),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  onPressed: () {
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                          0,
                          0,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  label: Text(
                    AppLocalizations.of(context)!.snooze,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Alarm.stop(alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.stop,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
