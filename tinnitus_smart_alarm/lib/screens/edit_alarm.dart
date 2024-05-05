import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/extended_alarm.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/screens/shortcut_button.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/volume_slider.dart';

class AlarmEditScreen extends StatefulWidget {
  final ExtendedAlarm? extendedAlarm;
  final void Function() refreshAlarms;
  final AlarmManager alarmManager;

  const AlarmEditScreen({
    Key? key,
    this.extendedAlarm,
    required this.refreshAlarms,
    required this.alarmManager,
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
  late bool isActive;
  late bool isRepeated;
  late String alarmName;
  late List<bool> repeatDays;
  final TextEditingController _nameController = TextEditingController();
  final double fadeDurationLength = 60;
  final SettingsManager settingsManager = SettingsManager();
  late final Future<void> _settingsFuture;
  late final Future<void> _stimuliFuture;
  List<Stimuli> stimuliList = [];
  StimuliManager stimuliManager = StimuliManager();
  late Stimuli selectedStimuli;

  @override
  void initState() {
    super.initState();
    creating = widget.extendedAlarm == null;
    fadeDuration = fadeDurationLength;
    _settingsFuture = _loadSettings();
    _stimuliFuture = _loadStimuliList();
    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/tinnitus_stimuli/marimba.mp3';
      fadeDuration = fadeDuration;
      alarmName = "Neuer Alarm";
      isActive = true;
      isRepeated = false;
      repeatDays = List.filled(7, false);
    } else {
      final alarmSettings = widget.extendedAlarm!.alarmSettings;
      selectedDateTime = alarmSettings.dateTime;
      loopAudio = alarmSettings.loopAudio;
      vibrate = alarmSettings.vibrate;
      volume = alarmSettings.volume;
      assetAudio = alarmSettings.assetAudioPath;
      fadeDuration = alarmSettings.fadeDuration;
      alarmName = widget.extendedAlarm!.name;
      isActive = widget.extendedAlarm!.isActive;
      isRepeated = widget.extendedAlarm!.isRepeated;
      repeatDays = List.from(widget.extendedAlarm!.repeatDays);
    }
    _nameController.text = alarmName;
  }

  Future<void> _loadStimuliList() async {
    stimuliList = await stimuliManager.loadAllStimuli();
    setState(() {});
  }

  Future<void> _loadSettings() async {
    loopAudio = await settingsManager.getLoopAudioSetting() ?? true;
    vibrate = await settingsManager.getVibrateSetting();
    fadeDurationStatus = await settingsManager.getFadeInSetting() ?? true;
    volume = await settingsManager.getVolumeSetting() ?? 0.5;
    customVolume = await settingsManager.getCustomVolumeSetting() ?? true;
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

  ExtendedAlarm buildExtendedAlarm() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000
        : widget.extendedAlarm!.alarmSettings.id;

    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      volume: customVolume ? volume : null,
      fadeDuration: fadeDuration,
      assetAudioPath: assetAudio,
      notificationTitle: AppLocalizations.of(context)!.alarm,
      notificationBody: AppLocalizations.of(context)!.yourAlarmIsRinging,
      androidFullScreenIntent: true,
      enableNotificationOnKill: true,
    );

    return ExtendedAlarm(
      alarmSettings: alarmSettings,
      name: alarmName,
      isActive: isActive,
      isRepeated: isRepeated,
      repeatDays: repeatDays,
    );
  }

  void updateAlarmName(String value) {
    alarmName = value;
  }

  void updateActiveStatus(bool value) {
    setState(() {
      isActive = value;
    });
  }

  void updateRepeatDays(int index, bool selected) {
    setState(() {
      repeatDays[index] = selected;
    });
  }

  void updateLoopAudio(bool value) {
    setState(() {
      loopAudio = value;
    });
  }

  void updateVibrate(bool value) {
    setState(() {
      vibrate = value;
    });
  }

  void updateFadeDurationStatus(bool value) {
    setState(() {
      fadeDurationStatus = value;
      fadeDuration = fadeDurationStatus ? fadeDurationLength : 0;
    });
  }

  void updateCustomVolume(bool value) {
    setState(() {
      customVolume = value;
    });
  }

  void updateVolume(double newVolume) {
    setState(() {
      volume = newVolume;
    });
  }

  void updateSelectedStimuli(Stimuli? newValue) {
    if (newValue != null) {
      setState(() {
        selectedStimuli = newValue;
        assetAudio = newValue.isIndividual ?? true
            ? newValue.filename!
            : 'assets/tinnitus_stimuli/${newValue.filename!}';
      });
    }
  }

  void saveAlarm() {
    if (loading) return;
    setState(() => loading = true);

    final extendedAlarm = buildExtendedAlarm();
    widget.alarmManager.saveAlarm(extendedAlarm).then((_) async {
      if (isActive) {
        await Alarm.set(alarmSettings: extendedAlarm.alarmSettings);
      }
      if (mounted) {
        Navigator.pop(context, true);
      }
      setState(() => loading = false);
    });
  }

  void deleteAlarm() {
    Alarm.stop(widget.extendedAlarm!.alarmSettings.id).then((res) {
      if (res) {
        widget.alarmManager.deleteAlarm(widget.extendedAlarm!.alarmSettings.id);
        Navigator.pop(context, true);
      }
    });
  }

  List<DropdownMenuItem<Stimuli>> _getStimuliDropdownList() {
    List<DropdownMenuItem<Stimuli>> dropDownList = [];
    for (Stimuli s in stimuliList) {
      dropDownList.add(DropdownMenuItem<Stimuli>(
        value: s,
        child: Text('${s.displayName}'),
      ));
    }
    dropDownList.toSet().toList();
    return dropDownList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_settingsFuture, _stimuliFuture]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading settings'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
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
                      alarmSettings: buildExtendedAlarm().alarmSettings,
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
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
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
                          onChanged: updateAlarmName,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context)!.alarmTime,
                      style: Theme.of(context).textTheme.titleMedium),
                  trailing: RawMaterialButton(
                    onPressed: pickTime,
                    fillColor: Colors.grey[200],
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      child: Text(
                        TimeOfDay.fromDateTime(selectedDateTime)
                            .format(context),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                _buildSwitchTile(
                  title: AppLocalizations.of(context)!.isActive,
                  value: isActive,
                  onChanged: updateActiveStatus,
                ),
                const SizedBox(height: 10),
                _buildSwitchTile(
                  title: AppLocalizations.of(context)!.repeatDays,
                  value: isRepeated,
                  onChanged: (value) {
                    setState(() {
                      isRepeated = !isRepeated;
                      if (isRepeated) {
                        repeatDays = List.filled(7, false);
                      }
                    });
                  },
                ),

                isRepeated
                    ? Wrap(
                        spacing: 4,
                        children: List.generate(7, (index) {
                          final day = [
                            'Mo',
                            'Di',
                            'Mi',
                            'Do',
                            'Fr',
                            'Sa',
                            'So'
                          ];
                          return FilterChip(
                            showCheckmark: false,
                            label: Text(day[index]),
                            selected: repeatDays[index],
                            onSelected: (bool selected) =>
                                updateRepeatDays(index, selected),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Colors.grey[200],
                          );
                        }),
                      )
                    : Container(),
                // const Divider(),
                // _buildSection(
                //   title: AppLocalizations.of(context)!.general,
                //   children: [

                //   ],
                // ),
                const Divider(),
                _buildSection(
                  title: AppLocalizations.of(context)!.audioSettings,
                  children: [
                    _buildSwitchTile(
                      title: AppLocalizations.of(context)!.loopAlarmAudio,
                      value: loopAudio,
                      onChanged: updateLoopAudio,
                    ),
                    _buildSwitchTile(
                      title: AppLocalizations.of(context)!.vibrate,
                      value: vibrate,
                      onChanged: updateVibrate,
                    ),
                    _buildSwitchTile(
                      title: AppLocalizations.of(context)!.fadeIn,
                      value: fadeDurationStatus,
                      onChanged: updateFadeDurationStatus,
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.sound,
                          style: Theme.of(context).textTheme.titleMedium),
                      trailing: DropdownButton<Stimuli>(
                        value: stimuliList.firstWhere(
                          (s) => s.id == selectedStimuli.id,
                          orElse: () => stimuliList.first,
                        ),
                        items: _getStimuliDropdownList(),
                        onChanged: updateSelectedStimuli,
                      ),
                    ),
                    _buildSwitchTile(
                      title: AppLocalizations.of(context)!.customVolume,
                      value: customVolume,
                      onChanged: updateCustomVolume,
                    ),
                    if (customVolume)
                      ListTile(
                        leading: Icon(
                          volume! > 0.7
                              ? Icons.volume_up_rounded
                              : volume! > 0.1
                                  ? Icons.volume_down_rounded
                                  : Icons.volume_mute_rounded,
                        ),
                        title: VolumeSlider(
                          initialVolume: volume ?? 0.5,
                          onChanged: updateVolume,
                        ),
                      ),
                  ],
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
          ),
        );
      },
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return ExpansionTile(
      title: Text(title, style: Theme.of(context).textTheme.titleLarge),
      children: children,
    );
  }
}
