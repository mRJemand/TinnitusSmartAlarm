import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';

class AlarmTile extends StatefulWidget {
  final String title;
  final ExtendedAlarm alarm;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const AlarmTile({
    Key? key,
    required this.title,
    required this.alarm,
    required this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  String getRepeatDaysString() {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final selectedDays = List<String>.generate(
      7,
      (index) => widget.alarm.repeatDays[index] ? days[index] : '',
    ).where((day) => day.isNotEmpty).toList();

    return selectedDays.isEmpty
        ? 'Keine Wiederholung'
        : selectedDays.join(', ');
  }

  Future<void> toggleAlarm(bool value) async {
    setState(() {
      widget.alarm.isActive = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.alarm.alarmSettings.id.toString()),
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
          color: Colors.white,
        ),
      ),
      onDismissed: (_) => widget.onDismissed?.call(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TimeOfDay(
                      hour: widget.alarm.alarmSettings.dateTime.hour,
                      minute: widget.alarm.alarmSettings.dateTime.minute,
                    ).format(context),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.alarm.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    getRepeatDaysString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                  onPressed: () {
                    log('open alarm');
                    widget.onPressed();
                  },
                ),
                Switch(
                  value: widget.alarm.isActive,
                  onChanged: toggleAlarm,
                  activeColor: Colors.blueAccent,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
