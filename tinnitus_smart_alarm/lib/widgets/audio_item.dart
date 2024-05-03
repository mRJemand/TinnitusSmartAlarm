import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';

class AudioItem extends StatelessWidget {
  final Stimuli stimuli;
  final VoidCallback onPlayPressed;
  final VoidCallback onSetDefaultAudio;
  final ValueNotifier<String?> defaultAudioNotifier;
  final ValueNotifier<String?> playingStimuliNotifier;

  AudioItem({
    super.key,
    required this.stimuli,
    required this.onPlayPressed,
    required this.onSetDefaultAudio,
    required this.defaultAudioNotifier,
    required this.playingStimuliNotifier,
  });

  StimuliManager stimuliManager = StimuliManager();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: ValueListenableBuilder<String?>(
            valueListenable: defaultAudioNotifier,
            builder: (context, value, child) {
              return IconButton(
                icon: const Icon(
                  Icons.star,
                ),
                color: defaultAudioNotifier.value == stimuli.filename
                    ? Colors.yellow[700]
                    : null,
                onPressed: () {
                  defaultAudioNotifier.value = stimuli.filename;
                },
              );
            }),
        title: Text(stimuli.displayName ?? ''),
        subtitle: Text(stimuliManager.getCategoryLocalizedName(
            context, stimuli.categoryName ?? '')),
        trailing: ValueListenableBuilder<String?>(
            valueListenable: playingStimuliNotifier,
            builder: (context, playingId, child) {
              return IconButton(
                icon: Icon(
                    playingId == stimuli.id ? Icons.stop : Icons.play_arrow),
                onPressed: onPlayPressed,
              );
            }),
      ),
    );
  }
}
