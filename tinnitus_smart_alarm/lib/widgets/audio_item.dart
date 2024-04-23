import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';

class AudioItem extends StatefulWidget {
  final Stimuli stimuli;
  final bool isPlaying;
  final VoidCallback onPlayPressed;
  final VoidCallback onSetDefaultAudio;
  final String defaultAudio;

  const AudioItem({
    Key? key,
    required this.stimuli,
    required this.isPlaying,
    required this.onPlayPressed,
    required this.onSetDefaultAudio,
    required this.defaultAudio,
  }) : super(key: key);

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  StimuliManager stimuliManager = StimuliManager();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.stimuli.displayName ?? ''),
        subtitle: Text(stimuliManager.getCategoryLocalizedName(
            context, widget.stimuli.categoryName ?? '')),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(widget.defaultAudio == widget.stimuli.filename
                  ? Icons.star
                  : Icons.star_border),
              onPressed: widget.onSetDefaultAudio,
            ),
            IconButton(
              icon: Icon(widget.isPlaying ? Icons.stop : Icons.play_arrow),
              onPressed: widget.onPlayPressed,
            ),
          ],
        ),
      ),
    );
  }
}
