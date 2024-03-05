import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';

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
  late String assetAudio;

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      assetAudio = 'assets/marimba.mp3';
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volume;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
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
      assetAudioPath: assetAudio,
      notificationTitle: 'Alarm example',
      notificationBody: 'Your alarm ($id) is ringing',
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

  @override
  Widget build(BuildContext context) {
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
                  "Cancel",
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
                        "Save",
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
                'Loop alarm audio',
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
                'Vibrate',
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
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/applause.mp3',
                    child: Text('applause'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/beachwaves.mp3',
                    child: Text('beachwaves'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/bees.mp3',
                    child: Text('bees'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/birdwings.mp3',
                    child: Text('birdwings'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/bonfire.mp3',
                    child: Text('bonfire'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/bubbling.mp3',
                    child: Text('bubbling'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/churchbells.mp3',
                    child: Text('churchbells'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/cicada.mp3',
                    child: Text('cicada'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/creakingdoor.mp3',
                    child: Text('creakingdoor'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/crowdbabble2.mp3',
                    child: Text('crowdbabble2'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/deep_am_10.mp3',
                    child: Text('deep_am_10'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/deep_am_4.mp3',
                    child: Text('deep_am_4'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/deep_am_40.mp3',
                    child: Text('deep_am_40'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/deep_pure.mp3',
                    child: Text('deep_pure'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/desertwind.mp3',
                    child: Text('desertwind'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/didgeridoo.mp3',
                    child: Text('didgeridoo'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/flappingflag.mp3',
                    child: Text('flappingflag'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_1000.mp3',
                    child: Text('fm_am_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_1000.mp3',
                    child: Text('fm_am_10_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_2000.mp3',
                    child: Text('fm_am_10_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_250.mp3',
                    child: Text('fm_am_10_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_3000.mp3',
                    child: Text('fm_am_10_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_4000.mp3',
                    child: Text('fm_am_10_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_500.mp3',
                    child: Text('fm_am_10_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_6000.mp3',
                    child: Text('fm_am_10_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_10_8000.mp3',
                    child: Text('fm_am_10_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_2000.mp3',
                    child: Text('fm_am_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_250.mp3',
                    child: Text('fm_am_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_3000.mp3',
                    child: Text('fm_am_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4000.mp3',
                    child: Text('fm_am_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_1000.mp3',
                    child: Text('fm_am_40_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_2000.mp3',
                    child: Text('fm_am_40_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_250.mp3',
                    child: Text('fm_am_40_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_3000.mp3',
                    child: Text('fm_am_40_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_4000.mp3',
                    child: Text('fm_am_40_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_500.mp3',
                    child: Text('fm_am_40_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_6000.mp3',
                    child: Text('fm_am_40_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_40_8000.mp3',
                    child: Text('fm_am_40_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_1000.mp3',
                    child: Text('asfm_am_4_1000dasd'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_2000.mp3',
                    child: Text('fm_am_4_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_250.mp3',
                    child: Text('fm_am_4_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_3000.mp3',
                    child: Text('fm_am_4_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_4000.mp3',
                    child: Text('fm_am_4_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_500.mp3',
                    child: Text('fm_am_4_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_6000.mp3',
                    child: Text('fm_am_4_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_4_8000.mp3',
                    child: Text('fm_am_4_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_500.mp3',
                    child: Text('fm_am_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_6000.mp3',
                    child: Text('fm_am_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/fm_am_8000.mp3',
                    child: Text('fm_am_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/frogs.mp3',
                    child: Text('frogs'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/gong.mp3',
                    child: Text('gong'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/kettle.mp3',
                    child: Text('kettle'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/laughingkids.mp3',
                    child: Text('laughingkids'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/mice.mp3',
                    child: Text('mice'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_1000.mp3',
                    child: Text('notchedmeditation_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_2000.mp3',
                    child: Text('notchedmeditation_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_250.mp3',
                    child: Text('notchedmeditation_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_3000.mp3',
                    child: Text('notchedmeditation_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_4000.mp3',
                    child: Text('notchedmeditation_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_500.mp3',
                    child: Text('notchedmeditation_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_6000.mp3',
                    child: Text('notchedmeditation_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmeditation_8000.mp3',
                    child: Text('notchedmeditation_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_1000.mp3',
                    child: Text('notchedmusic_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_2000.mp3',
                    child: Text('notchedmusic_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_250.mp3',
                    child: Text('notchedmusic_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_3000.mp3',
                    child: Text('notchedmusic_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_4000.mp3',
                    child: Text('notchedmusic_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_500.mp3',
                    child: Text('notchedmusic_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_6000.mp3',
                    child: Text('notchedmusic_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/notchedmusic_8000.mp3',
                    child: Text('notchedmusic_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/pink.mp3',
                    child: Text('pink'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/pink_10.mp3',
                    child: Text('pink_10'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/pink_4.mp3',
                    child: Text('pink_4'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/pink_40.mp3',
                    child: Text('pink_40'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/purple.mp3',
                    child: Text('purple'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/purple_10.mp3',
                    child: Text('purple_10'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/purple_4.mp3',
                    child: Text('purple_4'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/purple_40.mp3',
                    child: Text('purple_40'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/purringcat.mp3',
                    child: Text('asdapurringcatsd'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/rain.mp3',
                    child: Text('rain'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/rustlingleaves.mp3',
                    child: Text('rustlingleaves'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/screamingkids.mp3',
                    child: Text('screamingkids'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/seagulls.mp3',
                    child: Text('seagulls'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/shower.mp3',
                    child: Text('shower'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/sparrows.mp3',
                    child: Text('sparrows'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/teethbrushing.mp3',
                    child: Text('teethbrushing'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_1000.mp3',
                    child: Text('tin_am_10_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_2000.mp3',
                    child: Text('tin_am_10_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_250.mp3',
                    child: Text('tin_am_10_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_3000.mp3',
                    child: Text('tin_am_10_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_4000.mp3',
                    child: Text('tin_am_10_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_500.mp3',
                    child: Text('tin_am_10_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_6000.mp3',
                    child: Text('tin_am_10_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_10_8000.mp3',
                    child: Text('tin_am_10_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_1000.mp3',
                    child: Text('tin_am_40_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_2000.mp3',
                    child: Text('tin_am_40_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_250.mp3',
                    child: Text('tin_am_40_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_3000.mp3',
                    child: Text('tin_am_40_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_4000.mp3',
                    child: Text('tin_am_40_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_500.mp3',
                    child: Text('tin_am_40_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_6000.mp3',
                    child: Text('tin_am_40_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_40_8000.mp3',
                    child: Text('tin_am_40_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_1000.mp3',
                    child: Text('tin_am_4_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_2000.mp3',
                    child: Text('tin_am_4_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_250.mp3',
                    child: Text('tin_am_4_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_3000.mp3',
                    child: Text('tin_am_4_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_4000.mp3',
                    child: Text('tin_am_4_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_500.mp3',
                    child: Text('tin_am_4_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_6000.mp3',
                    child: Text('tin_am_4_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_am_4_8000.mp3',
                    child: Text('tin_am_4_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_1000.mp3',
                    child: Text('tin_pure_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_2000.mp3',
                    child: Text('tin_pure_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_250.mp3',
                    child: Text('tin_pure_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_3000.mp3',
                    child: Text('tin_pure_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_4000.mp3',
                    child: Text('tin_pure_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_500.mp3',
                    child: Text('tin_pure_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_6000.mp3',
                    child: Text('tin_pure_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tin_pure_8000.mp3',
                    child: Text('tin_pure_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/tumblingrocks.mp3',
                    child: Text('tumblingrocks'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/waterfall.mp3',
                    child: Text('waterfall'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/whales.mp3',
                    child: Text('whales'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn.mp3',
                    child: Text('wn'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10.mp3',
                    child: Text('wn_am_10'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_1000.mp3',
                    child: Text('wn_am_10_bp_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_2000.mp3',
                    child: Text('wn_am_10_bp_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_250.mp3',
                    child: Text('wn_am_10_bp_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_3000.mp3',
                    child: Text('wn_am_10_bp_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_4000.mp3',
                    child: Text('wn_am_10_bp_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_500.mp3',
                    child: Text('wn_am_10_bp_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_6000.mp3',
                    child: Text('wn_am_10_bp_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_bp_8000.mp3',
                    child: Text('wn_am_10_bp_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_1000.mp3',
                    child: Text('wn_am_10_notch_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_2000.mp3',
                    child: Text('wn_am_10_notch_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_250.mp3',
                    child: Text('wn_am_10_notch_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_3000.mp3',
                    child: Text('wn_am_10_notch_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_4000.mp3',
                    child: Text('wn_am_10_notch_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_500.mp3',
                    child: Text('wn_am_10_notch_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_6000.mp3',
                    child: Text('wn_am_10_notch_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_10_notch_8000.mp3',
                    child: Text('wn_am_10_notch_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4.mp3',
                    child: Text('wn_am_4'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40.mp3',
                    child: Text('wn_am_40'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_1000.mp3',
                    child: Text('wn_am_40_bp_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_2000.mp3',
                    child: Text('wn_am_40_bp_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_250.mp3',
                    child: Text('wn_am_40_bp_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_3000.mp3',
                    child: Text('wn_am_40_bp_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_4000.mp3',
                    child: Text('wn_am_40_bp_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_500.mp3',
                    child: Text('wn_am_40_bp_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_6000.mp3',
                    child: Text('wn_am_40_bp_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_bp_8000.mp3',
                    child: Text('wn_am_40_bp_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_1000.mp3',
                    child: Text('wn_am_40_notch_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_2000.mp3',
                    child: Text('wn_am_40_notch_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_250.mp3',
                    child: Text('wn_am_40_notch_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_3000.mp3',
                    child: Text('wn_am_40_notch_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_4000.mp3',
                    child: Text('wn_am_40_notch_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_500.mp3',
                    child: Text('wn_am_40_notch_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_6000.mp3',
                    child: Text('wn_am_40_notch_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_40_notch_8000.mp3',
                    child: Text('wn_am_40_notch_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_1000.mp3',
                    child: Text('wn_am_4_bp_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_2000.mp3',
                    child: Text('wn_am_4_bp_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_250.mp3',
                    child: Text('wn_am_4_bp_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_3000.mp3',
                    child: Text('wn_am_4_bp_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_4000.mp3',
                    child: Text('wn_am_4_bp_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_500.mp3',
                    child: Text('wn_am_4_bp_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_6000.mp3',
                    child: Text('wn_am_4_bp_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_bp_8000.mp3',
                    child: Text('wn_am_4_bp_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_1000.mp3',
                    child: Text('wn_am_4_notch_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_2000.mp3',
                    child: Text('wn_am_4_notch_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_250.mp3',
                    child: Text('wn_am_4_notch_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_3000.mp3',
                    child: Text('wn_am_4_notch_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_4000.mp3',
                    child: Text('wn_am_4_notch_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_500.mp3',
                    child: Text('wn_am_4_notch_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_6000.mp3',
                    child: Text('wn_am_4_notch_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_am_4_notch_8000.mp3',
                    child: Text('wn_am_4_notch_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_1000.mp3',
                    child: Text('wn_bp_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_2000.mp3',
                    child: Text('wn_bp_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_250.mp3',
                    child: Text('wn_bp_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_3000.mp3',
                    child: Text('wn_bp_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_4000.mp3',
                    child: Text('wn_bp_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_500.mp3',
                    child: Text('wn_bp_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_6000.mp3',
                    child: Text('wn_bp_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_bp_8000.mp3',
                    child: Text('wn_bp_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_1000.mp3',
                    child: Text('wn_notch_1000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_2000.mp3',
                    child: Text('wn_notch_2000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_250.mp3',
                    child: Text('wn_notch_250'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_3000.mp3',
                    child: Text('wn_notch_3000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_4000.mp3',
                    child: Text('wn_notch_4000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_500.mp3',
                    child: Text('wn_notch_500'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_6000.mp3',
                    child: Text('wn_notch_6000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/wn_notch_8000.mp3',
                    child: Text('wn_notch_8000'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/tinnitus_stimuli/writing.mp3',
                    child: Text('writing'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom volume',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != null,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: volume != null
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
                'Delete Alarm',
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
  }
}
