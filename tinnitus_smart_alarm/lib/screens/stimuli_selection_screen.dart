import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
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
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stimuli),
      ),
      body: ListView.builder(
        itemCount: StimuliCatalog.stimuliList.length,
        itemBuilder: (context, index) {
          Stimuli stimuli = StimuliCatalog.stimuliList[index];
          return AudioItem(
            stimuli: stimuli,
            isPlaying: playingStimuliId == stimuli.id,
            onPlayPressed: () => playStimuli(stimuli.id!, stimuli.filename!),
          );
        },
      ),
    );
  }
}
