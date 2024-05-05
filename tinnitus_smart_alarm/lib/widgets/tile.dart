import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';

class AlarmTile extends StatelessWidget {
  final ExtendedAlarm alarm;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const AlarmTile({
    Key? key,
    required this.alarm,
    required this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  String getRepeatDaysString() {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    final selectedDays = List<String>.generate(
      7,
      (index) => alarm.repeatDays[index] ? days[index] : '',
    ).where((day) => day.isNotEmpty).toList();

    return selectedDays.isEmpty
        ? 'Keine Wiederholung'
        : selectedDays.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(alarm.alarmSettings.id.toString()),
      direction: onDismissed != null
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
      onDismissed: (_) => onDismissed?.call(),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        onPressed: onPressed,
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
                        hour: alarm.alarmSettings.dateTime.hour,
                        minute: alarm.alarmSettings.dateTime.minute,
                      ).format(context),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alarm.name,
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
                  Switch(
                    value: alarm.isActive,
                    onChanged: (value) => onPressed(),
                    activeColor: Colors.blueAccent,
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
