import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';

class AudioItem extends StatelessWidget {
  final Stimuli stimuli;
  final bool isPlaying;
  final VoidCallback onPlayPressed;

  const AudioItem({
    Key? key,
    required this.stimuli,
    required this.isPlaying,
    required this.onPlayPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(stimuli.filename ?? ''),
        subtitle: Text(stimuli.categoryName ?? ''),
        trailing: IconButton(
          icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
          onPressed: onPlayPressed,
        ),
      ),
    );
  }
}
