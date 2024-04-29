import 'package:flutter/material.dart';

class VolumeControl extends StatefulWidget {
  final double initialVolume;
  final Function(double) onVolumeChanged;

  const VolumeControl({
    Key? key,
    required this.initialVolume,
    required this.onVolumeChanged,
  }) : super(key: key);

  @override
  _VolumeControlState createState() => _VolumeControlState();
}

class _VolumeControlState extends State<VolumeControl> {
  late double currentVolume;

  @override
  void initState() {
    super.initState();
    currentVolume = widget.initialVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: currentVolume,
      onChanged: (value) {
        setState(() => currentVolume = value);
        widget.onVolumeChanged(value);
      },
    );
  }
}
