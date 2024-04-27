import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';

class AlarmHomeShortcutButton extends StatefulWidget {
  final void Function() refreshAlarms;
  final AlarmSettings alarmSettings;

  const AlarmHomeShortcutButton(
      {Key? key, required this.refreshAlarms, required this.alarmSettings})
      : super(key: key);

  @override
  State<AlarmHomeShortcutButton> createState() =>
      _AlarmHomeShortcutButtonState();
}

class _AlarmHomeShortcutButtonState extends State<AlarmHomeShortcutButton> {
  bool showMenu = false;

  Future<void> onPressButton(int delayInHours) async {
    DateTime dateTime = DateTime.now().add(Duration(hours: delayInHours));

    if (delayInHours != 0) {
      dateTime = dateTime.copyWith(second: 0, millisecond: 0);
      // volume = 0.5;
    }

    setState(() => showMenu = false);

    // final myAlarmSettings = AlarmSettings(
    //   id: DateTime.now().millisecondsSinceEpoch % 10000,
    //   dateTime: dateTime,
    //   assetAudioPath: widget.alarmSettings.assetAudioPath,
    //   volume: widget.alarmSettings.volume,
    //   notificationTitle: 'Alarm example',
    //   notificationBody:
    //       'Shortcut button alarm with delay of $delayInHours hours',
    // );

    await Alarm.set(alarmSettings: widget.alarmSettings);

    widget.refreshAlarms();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onLongPress: () {
            setState(() => showMenu = true);
          },
          child: FloatingActionButton(
            onPressed: () => onPressButton(0),
            backgroundColor: Colors.redAccent,
            heroTag: UniqueKey(),
            child: const Text("TEST RING", textAlign: TextAlign.center),
          ),
        ),
        // if (showMenu)
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     TextButton(
        //       onPressed: () => onPressButton(24),
        //       child: const Text("+24h"),
        //     ),
        //     TextButton(
        //       onPressed: () => onPressButton(36),
        //       child: const Text("+36h"),
        //     ),
        //     TextButton(
        //       onPressed: () => onPressButton(48),
        //       child: const Text("+48h"),
        //     ),
        //  ],
        //  ),
      ],
    );
  }
}
