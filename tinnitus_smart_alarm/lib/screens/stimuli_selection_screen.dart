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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stimuli),
      ),
      body: ListView.builder(
        itemCount: stimuliList.length,
        itemBuilder: (context, index) {
          Stimuli stimuli = stimuliList[index];
          // Angenommen, AudioItem erwartet einen Stimuli-Parameter für die Initialisierung
          return AudioItem(stimuli: stimuli);
        },
      ),
    );
  }
}
