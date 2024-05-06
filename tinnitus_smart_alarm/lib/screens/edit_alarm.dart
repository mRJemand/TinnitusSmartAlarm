import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/screens/shortcut_button.dart';
import 'package:tinnitus_smart_alarm/services/alarm_manager.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/volume_slider.dart';

class AlarmEditScreen extends StatefulWidget {
  final AlarmSettings? alarmSettings;
  final ExtendedAlarm? extendedAlarm;
  final void Function() refreshAlarms;

  const AlarmEditScreen({
    Key? key,
    this.alarmSettings,
    this.extendedAlarm,
    required this.refreshAlarms,
  }) : super(key: key);

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
  final SettingsManager settingsManager = SettingsManager();
  late final Future<void> _settingsFuture;
  late final Future<void> _stimuliFuture;
  List<Stimuli> stimuliList = [];
  StimuliManager stimuliManager = StimuliManager();
  late Stimuli selectedStimuli;
  final TextEditingController _nameController = TextEditingController();
  late bool isActive;
  late String alarmName;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;
    fadeDuration = fadeDurationLength;
    _settingsFuture = _loadSettings(creating);
    _stimuliFuture = _loadStimuliList();
    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/tinnitus_stimuli/marimba.mp3';
      fadeDuration = fadeDuration;
    } else {
      log('asd');
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
      fadeDuration = widget.alarmSettings!.fadeDuration;
    }
    if (widget.extendedAlarm == null) {
      isActive = true;
    }
    isActive = widget.extendedAlarm?.isActive ?? true;

    customVolume = widget.extendedAlarm?.customVolume ?? true;
    volume = widget.extendedAlarm?.alarmSettings.volume ?? 0.5;
    fadeDurationStatus = widget.extendedAlarm?.isActive ?? true;

    alarmName = _nameController.text;
  }

  Future<void> _loadStimuliList() async {
    stimuliList = await stimuliManager.loadAllStimuli();
    setState(() {});
  }

  Future<void> _loadSettings(bool creating) async {
    if (creating) {
      loopAudio = await settingsManager.getLoopAudioSetting() ?? true;
      vibrate = await settingsManager.getVibrateSetting();
      fadeDurationStatus = await settingsManager.getFadeInSetting() ?? true;
      volume = await settingsManager.getVolumeSetting() ?? 0.5;
      customVolume = await settingsManager.getCustomVolumeSetting() ?? true;
    }
    assetAudio = await settingsManager.getAssetAudioSetting();
    Stimuli? selectedAssetAudio =
        await stimuliManager.loadStimuliByFileName(assetAudio);

    if (selectedAssetAudio == null) {
      assetAudio = await settingsManager.getAssetAudioSetting();
      selectedAssetAudio = stimuliList.first;
    } else {
      selectedAssetAudio.isIndividual ?? false
          ? assetAudio = selectedAssetAudio.filename!
          : assetAudio =
              'assets/tinnitus_stimuli/${selectedAssetAudio.filename!}';
    }
    selectedStimuli = selectedAssetAudio;
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

  AlarmSettings buildAlarmSettings({
    required bool isTestAlarm,
  }) {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000
        : widget.alarmSettings!.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: isTestAlarm ? DateTime.now() : selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: customVolume ? volume : null,
      fadeDuration: fadeDuration,
      assetAudioPath: assetAudio,
      notificationTitle: AppLocalizations.of(context)!.alarm,
      notificationBody: AppLocalizations.of(context)!.yourAlarmIsRinging,
    );
    return alarmSettings;
  }

  void saveAlarm() async {
    setState(() {});
    if (loading) return;
    setState(() => loading = true);
    log(buildAlarmSettings(isTestAlarm: false).toString());
    ExtendedAlarm extendedAlarm = ExtendedAlarm(
        alarmSettings: buildAlarmSettings(isTestAlarm: false),
        name: _nameController.text,
        isActive: isActive,
        isRepeated: false,
        customVolume: customVolume,
        repeatDays: [
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ]);
    await AlarmManager.setAlarmActive(extendedAlarm);
    // await AlarmManager.setAlarmActive(extendedAlarm);
    // Alarm.set(alarmSettings: buildAlarmSettings(isTestAlarm: false))
    //     .then((res) {
    //   if (res) Navigator.pop(context, true);
    // });
    Navigator.pop(context, true);
    setState(() => loading = false);
  }

  void deleteAlarm() {
    AlarmManager.deleteAlarm(widget.alarmSettings!.id);
    // Alarm.stop(widget.alarmSettings!.id).then((res) {
    //   if (res) Navigator.pop(context, true);
    // });
    Navigator.pop(context, true);
  }

  List<DropdownMenuItem<Stimuli>> _getStimuliDropdownList() {
    List<DropdownMenuItem<Stimuli>> dropDownList = [];
    for (Stimuli s in stimuliList) {
      dropDownList.add(DropdownMenuItem<Stimuli>(
        value: s,
        child: Text('${s.displayName}'),
      ));
    }
    print(dropDownList.first);
    dropDownList.toSet().toList();
    return dropDownList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_settingsFuture, _stimuliFuture]),
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.waiting) {
        //   return const Center(child: CircularProgressIndicator());
        // } else
        if (snapshot.hasError) {
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
                  AlarmHomeShortcutButton(
                    refreshAlarms: widget.refreshAlarms,
                    alarmSettings: buildAlarmSettings(isTestAlarm: true),
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
                    AppLocalizations.of(context)!.isActive,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Switch(
                    value: isActive,
                    onChanged: (value) => setState(() => isActive = value),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          alarmName = value;
                        });
                      },
                    ),
                  ),
                ],
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
                  DropdownButton<Stimuli>(
                    value: stimuliList.firstWhere(
                        (s) => s.id == selectedStimuli.id,
                        orElse: () => stimuliList.first),
                    items: _getStimuliDropdownList(),
                    onChanged: (Stimuli? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedStimuli = newValue;
                          newValue.isIndividual ?? true
                              ? assetAudio = newValue.filename!
                              : assetAudio =
                                  'assets/tinnitus_stimuli/${newValue.filename!}';
                        });
                      }
                    },
                  )
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
                            child: VolumeSlider(
                              initialVolume: volume ?? 0.5,
                              onChanged: (newVolume) {
                                if (volume != newVolume) {
                                  volume = newVolume;
                                }
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
