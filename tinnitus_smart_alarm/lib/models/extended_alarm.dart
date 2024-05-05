import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/alarm.dart';

class ExtendedAlarm {
  final AlarmSettings alarmSettings;
  String name;
  bool isActive;
  List<bool> repeatDays;

  ExtendedAlarm({
    required this.alarmSettings,
    required this.name,
    required this.isActive,
    required this.repeatDays,
  });

  ExtendedAlarm copyWith({
    AlarmSettings? alarmSettings,
    String? name,
    bool? isActive,
    List<bool>? repeatDays,
  }) {
    return ExtendedAlarm(
      alarmSettings: alarmSettings ?? this.alarmSettings,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }
}

class AlarmManager {
  List<ExtendedAlarm> alarms = [];

  List<ExtendedAlarm> loadAlarms() {
    // Lade Alarme aus einer vorhandenen Quelle, hier nur als Platzhalter
    alarms = Alarm.getAlarms().map((alarm) {
      return ExtendedAlarm(
        alarmSettings: alarm,
        name: "Alarm ${alarm.id}",
        isActive: true,
        repeatDays: List.filled(7, false),
      );
    }).toList();
    return alarms;
  }

  void saveAlarm(ExtendedAlarm alarm) {
    final index =
        alarms.indexWhere((a) => a.alarmSettings.id == alarm.alarmSettings.id);
    if (index >= 0) {
      alarms[index] = alarm;
    } else {
      alarms.add(alarm);
    }
  }

  void deleteAlarm(int id) {
    alarms.removeWhere((alarm) => alarm.alarmSettings.id == id);
  }
}
