import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:alarm/alarm.dart';

class AlarmTile extends StatefulWidget {
  final ExtendedAlarm alarm;
  final void Function() onPressed;
  final void Function()? onDismissed;

  const AlarmTile({
    Key? key,
    required this.alarm,
    required this.onPressed,
    this.onDismissed,
  }) : super(key: key);

  @override
  State<AlarmTile> createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {
  late bool isActive;

  @override
  void initState() {
    super.initState();
    isActive = widget.alarm.isActive;
  }

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
      isActive = value;
    });

    final AlarmManager alarmManager = AlarmManager();
    var updatedAlarm = widget.alarm.copyWith(isActive: isActive);

    if (isActive) {
      final now = DateTime.now();
      var alarmTime = updatedAlarm.alarmSettings.dateTime;
      if (alarmTime.isBefore(now)) {
        if (updatedAlarm.isRepeated) {
          alarmTime = alarmManager.getNextRepeatingDateTime(
              alarmTime, updatedAlarm.repeatDays);
        } else {
          alarmTime = alarmTime.add(const Duration(days: 1));
        }
        updatedAlarm = updatedAlarm.copyWith(
          alarmSettings:
              updatedAlarm.alarmSettings.copyWith(dateTime: alarmTime),
        );
      }
      await alarmManager.saveAlarm(updatedAlarm);
    } else {
      await Alarm.stop(updatedAlarm.alarmSettings.id);
      await alarmManager.saveAlarm(updatedAlarm);
    }
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.blueAccent,
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          elevation: 0,
        ),
        onPressed: widget.onPressed,
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
                  Switch(
                    value: isActive,
                    onChanged: toggleAlarm,
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
