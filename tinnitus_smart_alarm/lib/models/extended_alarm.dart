import 'package:alarm/model/alarm_settings.dart';

class ExtendedAlarm {
  AlarmSettings alarmSettings;
  String name;
  bool isActive;
  bool isRepeated;
  List<bool> repeatDays;
  bool? customVolume;

  ExtendedAlarm(
      {required this.alarmSettings,
      required this.name,
      required this.isActive,
      required this.isRepeated,
      required this.repeatDays,
      required this.customVolume});

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
      customVolume: customVolume ?? customVolume,
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
      customVolume: json['customVolume'],
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
      'customVolume': customVolume,
      'repeatDays': repeatDays,
    };
  }
}
