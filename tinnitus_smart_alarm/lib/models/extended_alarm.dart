import 'dart:convert';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtendedAlarm {
  final AlarmSettings alarmSettings;
  String name;
  bool isActive;
  bool isRepeated;
  List<bool> repeatDays;

  ExtendedAlarm({
    required this.alarmSettings,
    required this.name,
    required this.isActive,
    required this.isRepeated,
    required this.repeatDays,
  });

  ExtendedAlarm copyWith({
    AlarmSettings? alarmSettings,
    String? name,
    bool? isActive,
    bool? isRepeated,
    List<bool>? repeatDays,
  }) {
    return ExtendedAlarm(
      alarmSettings: alarmSettings ?? this.alarmSettings,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      isRepeated: isRepeated ?? this.isRepeated,
      repeatDays: repeatDays ?? this.repeatDays,
    );
  }

  factory ExtendedAlarm.fromJson(Map<String, dynamic> json) {
    return ExtendedAlarm(
      alarmSettings: AlarmSettings(
        id: json['id'],
        dateTime: DateTime.parse(json['dateTime']),
        loopAudio: json['loopAudio'],
        vibrate: json['vibrate'],
        volume: json['volume'] != null ? json['volume'].toDouble() : null,
        fadeDuration: json['fadeDuration'].toDouble(),
        assetAudioPath: json['assetAudioPath'],
        notificationTitle: json['notificationTitle'],
        notificationBody: json['notificationBody'],
      ),
      name: json['name'],
      isActive: json['isActive'],
      isRepeated: json['isRepeated'],
      repeatDays: List<bool>.from(json['repeatDays']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': alarmSettings.id,
      'dateTime': alarmSettings.dateTime.toIso8601String(),
      'loopAudio': alarmSettings.loopAudio,
      'vibrate': alarmSettings.vibrate,
      'volume': alarmSettings.volume,
      'fadeDuration': alarmSettings.fadeDuration,
      'assetAudioPath': alarmSettings.assetAudioPath,
      'notificationTitle': alarmSettings.notificationTitle,
      'notificationBody': alarmSettings.notificationBody,
      'name': name,
      'isActive': isActive,
      'isRepeated': isRepeated,
      'repeatDays': repeatDays,
    };
  }
}

class AlarmManager {
  static const String _sharedPrefsKey = 'alarms';
  List<ExtendedAlarm> alarms = [];

  Future<void> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String? alarmsJson = prefs.getString(_sharedPrefsKey);
    if (alarmsJson != null) {
      final List<dynamic> alarmsList = jsonDecode(alarmsJson);
      alarms = alarmsList
          .map((alarmJson) => ExtendedAlarm.fromJson(alarmJson))
          .toList();
    } else {
      // Lade Alarme aus der Bibliothek als Platzhalter
      alarms = Alarm.getAlarms().map((alarm) {
        return ExtendedAlarm(
          alarmSettings: alarm,
          name: "Alarm ${alarm.id}",
          isActive: true,
          isRepeated: false,
          repeatDays: List.filled(7, false),
        );
      }).toList();
    }
  }

  Future<void> saveAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final String alarmsJson =
        jsonEncode(alarms.map((a) => a.toJson()).toList());
    await prefs.setString(_sharedPrefsKey, alarmsJson);
  }

  Future<void> saveAlarm(ExtendedAlarm alarm) async {
    final index =
        alarms.indexWhere((a) => a.alarmSettings.id == alarm.alarmSettings.id);
    if (index >= 0) {
      alarms[index] = alarm;
    } else {
      alarms.add(alarm);
    }

    // Wenn die Alarmzeit in der Vergangenheit liegt, aktualisiere auf die nächste mögliche Zeit.
    if (alarm.isActive) {
      final now = DateTime.now();
      var alarmTime = alarm.alarmSettings.dateTime;
      if (alarmTime.isBefore(now)) {
        if (alarm.isRepeated) {
          // Wähle die nächste Wiederholungszeit
          alarmTime = getNextRepeatingDateTime(alarmTime, alarm.repeatDays);
        } else {
          // Setze den Alarm auf den nächsten Tag
          alarmTime = alarmTime.add(const Duration(days: 1));
        }
        alarm = alarm.copyWith(
          alarmSettings: alarm.alarmSettings.copyWith(dateTime: alarmTime),
        );
      }
      await Alarm.set(alarmSettings: alarm.alarmSettings);
    } else {
      await Alarm.stop(alarm.alarmSettings.id);
    }

    await saveAlarms();
  }

  DateTime getNextRepeatingDateTime(DateTime dateTime, List<bool> repeatDays) {
    final now = DateTime.now();
    final weekdays = List.generate(7, (index) => index);
    for (int i = 0; i < 7; i++) {
      final dayIndex = (dateTime.weekday - 1 + i) % 7;
      if (repeatDays[dayIndex]) {
        final nextDate = dateTime.add(Duration(days: i));
        if (nextDate.isAfter(now)) {
          return nextDate;
        }
      }
    }
    return dateTime.add(const Duration(days: 7));
  }

  Future<void> deleteAlarm(int id) async {
    alarms.removeWhere((alarm) {
      if (alarm.alarmSettings.id == id) {
        Alarm.stop(alarm.alarmSettings.id);
      }
      return alarm.alarmSettings.id == id;
    });

    await saveAlarms();
  }
}
