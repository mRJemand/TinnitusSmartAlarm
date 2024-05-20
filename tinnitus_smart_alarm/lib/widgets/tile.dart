import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:tinnitus_smart_alarm/services/alarm_manager.dart';

class AlarmTile extends StatefulWidget {
  final String title;
  final ExtendedAlarm extendedAlarm;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const AlarmTile({
    Key? key,
    required this.title,
    required this.extendedAlarm,
    required this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  Future<void> toggleAlarm(bool value) async {
    if (value &&
        widget.extendedAlarm.alarmSettings.dateTime.isBefore(DateTime.now())) {
      // Set the alarm to the same time on the next day
      DateTime newDateTime =
          widget.extendedAlarm.alarmSettings.dateTime.add(Duration(days: 1));
      widget.extendedAlarm.alarmSettings =
          widget.extendedAlarm.alarmSettings.copyWith(dateTime: newDateTime);
    }

    setState(() {
      widget.extendedAlarm.isActive = value;
    });

    if (value) {
      await AlarmManager.setAlarmActive(widget.extendedAlarm);
    } else {
      await AlarmManager.setAlarmInactive(widget.extendedAlarm);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.extendedAlarm.alarmSettings.id.toString()),
      direction: widget.onDismissed != null
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 30),
        child: const Icon(
          Icons.delete,
          size: 30,
        ),
      ),
      onDismissed: (_) => widget.onDismissed?.call(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: widget.onPressed,
          child: Card(
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(12),
            //   boxShadow: const [
            //     BoxShadow(
            //       // color: Colors.black12,
            //       blurRadius: 8,
            //       offset: Offset(0, 4),
            //     ),
            //   ],
            // color: Colors.white,
            // ),
            // padding: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          TimeOfDay(
                            hour: widget
                                .extendedAlarm.alarmSettings.dateTime.hour,
                            minute: widget
                                .extendedAlarm.alarmSettings.dateTime.minute,
                          ).format(context),
                          style: Theme.of(context).textTheme.headlineLarge,
                          //     const TextStyle(
                          //   fontSize: 24,
                          //   fontWeight: FontWeight.w500,
                          //   color: Colors.black,
                          // ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.extendedAlarm.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            // color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: widget.extendedAlarm.isActive,
                    onChanged: toggleAlarm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
