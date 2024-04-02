import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_servics.dart';
import 'package:tinnitus_smart_alarm/widgets/audio_item.dart';

class StimuliSelectionScreen extends StatefulWidget {
  const StimuliSelectionScreen({super.key});

  @override
  State<StimuliSelectionScreen> createState() => _StimuliSelectionScreenState();
}

class _StimuliSelectionScreenState extends State<StimuliSelectionScreen> {
  List<Stimuli> stimuliList = StimuliCatalog.stimuliList;
  final AudioPlayer audioPlayer = AudioPlayer();
  int? playingStimuliId;
  final SettingsService settingsService = SettingsService();
  late final Future<void> _settingsFuture;
  late String defaultAudio;

  void playStimuli(int stimuliId, String filePath) async {
    if (playingStimuliId == stimuliId) {
      await audioPlayer.stop();
      setState(() => playingStimuliId = null);
    } else {
      await audioPlayer.play(AssetSource('tinnitus_stimuli/$filePath'));
      setState(() => playingStimuliId = stimuliId);
    }
  }

  @override
  void initState() {
    super.initState();

    _settingsFuture = _loadSettings();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    defaultAudio = await settingsService.getAssetAudioSetting() ?? '';
    setState(() {});
  }

  _setAudioAsDefault(String filename) {
    settingsService.setAssetAudioSetting(filename);
    setState(() {
      defaultAudio = filename;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(AppLocalizations.of(context)!.defaultAudioSaved(filename))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stimuli),
      ),
      body: FutureBuilder(
        future: _settingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child:
                    Text(AppLocalizations.of(context)!.errorLoadingSettings));
          }
          return ListView.builder(
            itemCount: StimuliCatalog.stimuliList.length,
            itemBuilder: (context, index) {
              Stimuli stimuli = StimuliCatalog.stimuliList[index];
              return AudioItem(
                stimuli: stimuli,
                isPlaying: playingStimuliId == stimuli.id,
                onPlayPressed: () =>
                    playStimuli(stimuli.id!, stimuli.filename!),
                onSetDefaultAudio: () => _setAudioAsDefault(stimuli.filename!),
                defaultAudio: defaultAudio,
              );
            },
          );
        },
      ),
    );
  }
}
