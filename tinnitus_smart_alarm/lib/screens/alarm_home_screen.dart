import 'dart:async';
import 'dart:developer';

import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/screens/edit_alarm.dart';
import 'package:tinnitus_smart_alarm/screens/ring_screen.dart';
import 'package:tinnitus_smart_alarm/screens/shortcut_button.dart';
import 'package:tinnitus_smart_alarm/services/alarm_manager.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/tile.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  late List<AlarmSettings> alarms;
  List<ExtendedAlarm?> extendedAlarms = [];
  late List<Stimuli> stimuliList;
  late final Future<void> _stimuliFuture;

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    if (Alarm.android) {
      checkAndroidNotificationPermission();
    }
    loadAlarms();
    _stimuliFuture = _loadStimuliList();
    subscription ??= Alarm.ringStream.stream.listen(
      (alarmSettings) => navigateToRingScreen(alarmSettings),
    );
    initialization();
  }

  void initialization() async {
    FlutterNativeSplash.remove();
  }

  void loadAlarms() async {
    extendedAlarms = await AlarmManager.loadAlarms();
    setState(() {});
    // log('LENGTH ${extendedAlarms.length}');
    setState(() {
      alarms = Alarm.getAlarms();
      alarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    });
  }

  Future<void> _loadStimuliList() async {
    StimuliManager stimuliManager = StimuliManager();
    stimuliList = await stimuliManager.loadAllStimuli();
    setState(() {});
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> navigateToAlarmScreen(ExtendedAlarm? alarm) async {
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (context) {
        log(alarm?.toJson().toString() ?? 'no json');
        return FractionallySizedBox(
          heightFactor: 0.75,
          child: AlarmEditScreen(
            alarmSettings: alarm?.alarmSettings,
            extendedAlarm: alarm,
            refreshAlarms: loadAlarms,
            stimuliList: stimuliList,
          ),
        );
      },
    );

    if (res != null && res == true) loadAlarms();
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted.',
      );
    }
  }

  Future<void> checkAndroidExternalStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isDenied) {
      alarmPrint('Requesting external storage permission...');
      final res = await Permission.storage.request();
      alarmPrint(
        'External storage permission ${res.isGranted ? '' : 'not'} granted.',
      );
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tinnitus Smart Alarm')),
      body: FutureBuilder(
        future: _stimuliFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading settings'));
          }
          return SafeArea(
            child: extendedAlarms.isNotEmpty
                ? ListView.separated(
                    itemCount: extendedAlarms.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      return AlarmTile(
                          key: Key(extendedAlarms[index]!
                              .alarmSettings
                              .id
                              .toString()),
                          title: TimeOfDay(
                            hour: extendedAlarms[index]!
                                .alarmSettings
                                .dateTime
                                .hour,
                            minute: extendedAlarms[index]!
                                .alarmSettings
                                .dateTime
                                .minute,
                          ).format(context),
                          onPressed: () =>
                              navigateToAlarmScreen(extendedAlarms[index]),
                          onDismissed: () {
                            // Alarm.stop(extendedAlarms[index].alarmSettings.id)
                            //     .then((_) => loadAlarms());
                            // AlarmManager.setAlarmInactive(extendedAlarms[index]);
                            AlarmManager.deleteAlarm(
                                extendedAlarms[index]!.alarmSettings.id);
                            loadAlarms();
                          },
                          extendedAlarm: extendedAlarms[index]!);
                    },
                  )
                : Center(
                    child: Text(
                      AppLocalizations.of(context)!.noAlarmsSet,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // AlarmHomeShortcutButton(refreshAlarms: loadAlarms),
            FloatingActionButton(
              heroTag: UniqueKey(),
              onPressed: () => navigateToAlarmScreen(null),
              child: const Icon(Icons.alarm_add_rounded, size: 33),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
