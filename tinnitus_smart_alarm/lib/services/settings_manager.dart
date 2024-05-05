import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
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
    return prefs.getDouble('volume') ?? 0.5;
  }

  Future<void> setVolumeSetting(double value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setDouble('volume', value);
  }

  Future<String?> getLocaleSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('locale');
  }

  Future<void> setLocaleSetting(String locale) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('locale', locale);
  }

  Future<String> getAssetAudioSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('assetAudio') ??
        'assets/tinnitus_stimuli/marimba.mp3';
  }

  Future<void> setAssetAudioSetting(String value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString('assetAudio', value);
  }

  Future<int> getSnoozeTimeSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt('snoozeTime') ?? 5;
  }

  Future<void> setSnoozeTimeSetting(int value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setInt('snoozeTime', value);
  }

  Future<bool?> getAllowDataCollectionSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('allowDataCollection');
  }

  Future<void> setAllowDataCollectionSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('allowDataCollection', value);
  }

  Future<bool?> getHasSeenOnboardingSetting() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getBool('hasSeenOnboarding');
  }

  Future<void> setHasSeenOnboardingSetting(bool value) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('hasSeenOnboarding', value);
  }
}
