import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/alarm_manager.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';

class AlarmRingScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;

  const AlarmRingScreen({Key? key, required this.alarmSettings})
      : super(key: key);

  @override
  State<AlarmRingScreen> createState() => _AlarmRingScreenState();
}

class _AlarmRingScreenState extends State<AlarmRingScreen> {
  String? alarmName = '';

  String getLastSegment(String path) {
    int index = path.lastIndexOf('/');
    return index == -1 ? path : path.substring(index + 1);
  }

  void _scheduleNotification(
      String notificationTitle, String notificationBody) {
    // todo change duration to 90 min
    Future.delayed(const Duration(seconds: 0), () async {
      DateTime scheduledTime = DateTime.now().add(const Duration(minutes: 30));
      StimuliManager stimuliManager = StimuliManager();
      Stimuli? stimuli = await stimuliManager.loadStimuliByFileName(
          getLastSegment(widget.alarmSettings.assetAudioPath));
      if (stimuli == null) {
        log('no Stimuli found by name');
        log(widget.alarmSettings.assetAudioPath);
      } else {
        log(stimuli.toString());
      }
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 1,
          channelKey: 'scheduled',
          title: notificationTitle,
          body: notificationBody,
          notificationLayout: NotificationLayout.Default,
          payload: {
            'stimuli': stimuli?.filename ?? '',
            'frequency': stimuli?.frequency ?? '',
          },
        ),
        schedule: NotificationCalendar.fromDate(date: scheduledTime),
        actionButtons: [
          NotificationActionButton(
            key: 'OPEN_SURVEY',
            label: 'Open Survey',
          ),
        ],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    log('MY ALARM NAME INIT');
    loadAlarmName();
    log('MY ALARM NAME 123');
  }

  Future<void> loadAlarmName() async {
    ExtendedAlarm? extendedAlarm =
        await AlarmManager.getAlarmById(widget.alarmSettings.id);

    log('MY ALARM NAME: ${extendedAlarm?.name ?? ''}');
    alarmName = extendedAlarm?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    log('Im ringing!!!');

    final SettingsManager settingsManager = SettingsManager();

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<int>(
          future: settingsManager.getSnoozeTimeSetting(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Ladezustand
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Fehlerzustand
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.errorLoadingSettings));
            }
            // Erfolgreicher Zustand
            final int snoozeTime =
                snapshot.data ?? 1; // Standardwert falls null
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  AppLocalizations.of(context)!.yourAlarmIsRinging,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  alarmName ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                // const Text("🔔", style: TextStyle(fontSize: 50)),
                Text(
                    TimeOfDay(
                      hour: widget.alarmSettings.dateTime.hour,
                      minute: widget.alarmSettings.dateTime.minute,
                    ).format(context),
                    style: Theme.of(context).textTheme.titleLarge),
                Center(
                  child:
                      Image.asset('assets/images/TinnitusSmartAlarmIcon.png'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      // icon: const Icon(Icons.snooze),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        final now = DateTime.now();
                        Alarm.set(
                          alarmSettings: widget.alarmSettings.copyWith(
                            dateTime: DateTime(
                              now.year,
                              now.month,
                              now.day,
                              now.hour,
                              now.minute,
                              0,
                              0,
                            ).add(Duration(minutes: snoozeTime)),
                          ),
                        ).then((_) => Navigator.pop(context));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.snooze,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        SettingsManager settingsManager = SettingsManager();
                        bool allowDataCollecting = await settingsManager
                                .getAllowDataCollectionSetting() ??
                            false;
                        if (allowDataCollecting) {
                          _scheduleNotification(
                              AppLocalizations.of(context)!.survey,
                              AppLocalizations.of(context)!.recordYourTinnitus);
                        }
                        Alarm.stop(widget.alarmSettings.id)
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
            );
          },
        ),
      ),
    );
  }
}
