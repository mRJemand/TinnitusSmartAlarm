import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_servics.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;

  const AlarmEditScreen({Key? key, this.alarmSettings}) : super(key: key);

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late bool customVolume;
  late String assetAudio;
  late double fadeDuration;
  late bool fadeDurationStatus;
  final double fadeDurationLength = 60;
  final SettingsService settingsService = SettingsService();
  late final Future<void> _settingsFuture;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;
    fadeDuration = fadeDurationLength;
    _settingsFuture = _loadSettings();
    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/tinnitus_stimuli/marimba.mp3';
      fadeDuration = fadeDuration;
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
      fadeDuration = widget.alarmSettings!.fadeDuration;
    }
  }

  Future<void> _loadSettings() async {
    loopAudio = await settingsService.getLoopAudioSetting() ?? true;
    vibrate = await settingsService.getVibrateSetting();
    fadeDurationStatus = await settingsService.getFadeInSetting() ?? true;
    volume = await settingsService.getVolumeSetting() ?? 0.5;
    customVolume = await settingsService.getCustomVolumeSetting() ?? true;
    assetAudio = await settingsService.getAssetAudioSetting();
    setState(() {});
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return AppLocalizations.of(context)!.today;
      case 1:
        return AppLocalizations.of(context)!.tomorrow;
      case 2:
        return AppLocalizations.of(context)!.afterTomorrow;
      default:
        return AppLocalizations.of(context)!.inXDays(difference);
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final DateTime now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: volume,
      fadeDuration: fadeDuration,
      assetAudioPath: 'assets/tinnitus_stimuli/$assetAudio',
      notificationTitle: AppLocalizations.of(context)!.alarm,
      notificationBody: AppLocalizations.of(context)!.yourAlarmIsRinging,
    );
    return alarmSettings;
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);

    Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
      if (res) Navigator.pop(context, true);
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res) Navigator.pop(context, true);
    });
  }

  List<DropdownMenuItem<String>> _getStimuliDropdownList() {
    List<DropdownMenuItem<String>> dropDownList = [];
    for (Stimuli s in StimuliCatalog.stimuliList) {
      dropDownList.add(DropdownMenuItem<String>(
        value: '${s.filename}',
        child: Text('${s.filename}'),
      ));
    }
    print(dropDownList.first);
    return dropDownList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _settingsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading settings'));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(
                      AppLocalizations.of(context)!.cancel,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: Colors.blueAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: saveAlarm,
                    child: loading
                        ? const CircularProgressIndicator()
                        : Text(
                            AppLocalizations.of(context)!.save,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.blueAccent),
                          ),
                  ),
                ],
              ),
              Text(
                getDay(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.blueAccent.withOpacity(0.8)),
              ),
              RawMaterialButton(
                onPressed: pickTime,
                fillColor: Colors.grey[200],
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    TimeOfDay.fromDateTime(selectedDateTime).format(context),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(color: Colors.blueAccent),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.loopAlarmAudio,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: loopAudio,
                    onChanged: (value) => setState(() => loopAudio = value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.vibrate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: vibrate,
                    onChanged: (value) => setState(() => vibrate = value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.fadeIn,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: fadeDurationStatus,
                    onChanged: (value) {
                      setState(() => fadeDurationStatus = value);
                      setState(() {
                        fadeDurationStatus
                            ? fadeDuration = fadeDurationLength
                            : fadeDuration = 0;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.sound,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  DropdownButton(
                    value: '$assetAudio',
                    items: <DropdownMenuItem<String>>[
                      // const DropdownMenuItem<String>(
                      //   value: 'assets/tinnitus_stimuli/marimba.mp3',
                      //   child: Text('Marimba'),
                      // ),
                      ..._getStimuliDropdownList(),
                    ],
                    // DropdownMenuItem<String>(
                    //   value: 'assets/nokia.mp3',
                    //   child: Text('Nokia'),
                    // ),
                    // DropdownMenuItem<String>(
                    //   value: 'assets/mozart.mp3',
                    //   child: Text('Mozart'),
                    // ),
                    // DropdownMenuItem<String>(
                    //   value: 'assets/star_wars.mp3',
                    //   child: Text('Star Wars'),
                    // ),
                    // DropdownMenuItem<String>(
                    //   value: 'assets/one_piece.mp3',
                    //   child: Text('One Piece'),
                    // ),

                    // ],
                    onChanged: (value) => setState(() => assetAudio = value!),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.customVolume,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: customVolume,
                    onChanged: (value) => setState(() => customVolume = value),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
                child: customVolume
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            volume! > 0.7
                                ? Icons.volume_up_rounded
                                : volume! > 0.1
                                    ? Icons.volume_down_rounded
                                    : Icons.volume_mute_rounded,
                          ),
                          Expanded(
                            child: Slider(
                              value: volume!,
                              onChanged: (value) {
                                setState(() => volume = value);
                              },
                            ),
                          ),
                        ],
                      )
                    : const SizedBox(),
              ),
              if (!creating)
                TextButton(
                  onPressed: deleteAlarm,
                  child: Text(
                    AppLocalizations.of(context)!.deleteAlarm,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.red),
                  ),
                ),
              const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}
