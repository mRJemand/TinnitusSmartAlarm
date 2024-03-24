import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> getDarkModeSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('darkMode') ?? true;
  }

  Future<void> setDarkModeSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('darkMode', value);
  }

  Future<bool> getLoopAudioSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('loopAlarmAudio') ?? true;
  }

  Future<void> setLoopAudioSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('loopAlarmAudio', value);
  }

  Future<bool> getVibrateSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('vibrate') ?? true;
  }

  Future<void> setVibrateSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('vibrate', value);
  }

  Future<bool> getFadeInSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('fadeIn') ?? true;
  }

  Future<void> setFadeInSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('fadeIn', value);
  }

  Future<bool> getCustomVolumeSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('customVolume') ?? true;
  }

  Future<void> setCustomVolumeSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('customVolume', value);
  }

  Future<double> getVolumeSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getDouble('volume') ?? 1.0;
  }

  Future<void> setVolumeSetting(double value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble('volume', value);
  }
}
