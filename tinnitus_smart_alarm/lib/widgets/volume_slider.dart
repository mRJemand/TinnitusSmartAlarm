import 'package:flutter/material.dart';

class VolumeSlider extends StatefulWidget {
  final double initialVolume;
  final ValueChanged<double> onChanged;

  const VolumeSlider({
    Key? key,
    required this.initialVolume,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<VolumeSlider> createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
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
      min: 0.0,
      max: 1.0,
      divisions: 100,
      label: "${(currentVolume * 100).toStringAsFixed(0)}%",
      onChanged: (double value) {
        setState(() {
          currentVolume = value;
        });
        widget.onChanged(value);
      },
    );
  }
}
