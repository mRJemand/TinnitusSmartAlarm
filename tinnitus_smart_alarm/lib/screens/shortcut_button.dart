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
    }

    setState(() => showMenu = false);

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
      ],
    );
  }
}
