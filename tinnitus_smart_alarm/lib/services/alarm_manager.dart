import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AlarmManager {
  static Future<void> setAlarmActive(ExtendedAlarm extendedAlarm) async {
    Alarm.set(alarmSettings: extendedAlarm.alarmSettings);
    saveOrUpdateAlarm(extendedAlarm);
    log('alarm set');
  }

  static Future<void> setAlarmInactive(ExtendedAlarm extendedAlarm) async {
    Alarm.stop(extendedAlarm.alarmSettings.id);
    saveOrUpdateAlarm(extendedAlarm);
    log('alarm deleted');
  }

  static const String _alarmsKey = 'extended_alarms';

  /// Speichert oder aktualisiert den Alarm in den Präferenzen.
  static Future<void> saveOrUpdateAlarm(ExtendedAlarm alarm) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString(_alarmsKey);
    final List<ExtendedAlarm> alarms = alarmsJson != null
        ? (jsonDecode(alarmsJson) as List<dynamic>)
            .map((item) => ExtendedAlarm.fromJson(item))
            .toList()
        : [];

    final index =
        alarms.indexWhere((a) => a.alarmSettings.id == alarm.alarmSettings.id);
    if (index != -1) {
      alarms[index] = alarm; // Aktualisiere den bestehenden Alarm
    } else {
      alarms.add(alarm); // Füge einen neuen Alarm hinzu
    }

    await prefs.setString(
        _alarmsKey, jsonEncode(alarms.map((e) => e.toJson()).toList()));
  }

  /// Lädt alle ExtendedAlarms aus den Präferenzen.
  static Future<List<ExtendedAlarm>> loadAlarms() async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString(_alarmsKey);
    if (alarmsJson != null) {
      final List<dynamic> jsonList = jsonDecode(alarmsJson);
      return jsonList.map((json) => ExtendedAlarm.fromJson(json)).toList();
    }
    return [];
  }

  /// Löscht einen Alarm aus den Präferenzen.
  static Future<void> deleteAlarm(int alarmId) async {
    final prefs = await SharedPreferences.getInstance();
    final alarmsJson = prefs.getString(_alarmsKey);
    if (alarmsJson != null) {
      final List<dynamic> jsonList = jsonDecode(alarmsJson);
      final List<ExtendedAlarm> alarms =
          jsonList.map((json) => ExtendedAlarm.fromJson(json)).toList();
      alarms.removeWhere((alarm) => alarm.alarmSettings.id == alarmId);
      await prefs.setString(
          _alarmsKey, jsonEncode(alarms.map((e) => e.toJson()).toList()));
    }
  }
}
