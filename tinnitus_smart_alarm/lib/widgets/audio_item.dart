import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart'; // Pfad entsprechend anpassen

class AudioItem extends StatefulWidget {
  final Stimuli stimuli;

  const AudioItem({Key? key, required this.stimuli}) : super(key: key);

  @override
  State<AudioItem> createState() => _AudioItemState();
}

class _AudioItemState extends State<AudioItem> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false; // Zustand, ob der Ton gerade abgespielt wird

  void toggleAudio() async {
    if (isPlaying) {
      await audioPlayer.stop(); // Stoppt die Wiedergabe
    } else {
      await audioPlayer.play(AssetSource(
          'tinnitus_stimuli/${widget.stimuli.filename}')); // Startet die Wiedergabe
    }
    setState(() {
      isPlaying = !isPlaying; // Aktualisiert den Zustand
    });
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(widget.stimuli.filename ?? ''),
        subtitle: Text(widget.stimuli.categoryName ?? ''),
        trailing: IconButton(
          icon: Icon(
              isPlaying ? Icons.stop : Icons.play_arrow), // Wechselt das Icon
          onPressed: toggleAudio,
        ),
      ),
    );
  }
}
