import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  List<Stimuli> filteredList = [];
  String? selectedCategory;
  String? selectedFrequency;
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
    filteredList = List.from(stimuliList);
    _settingsFuture = _loadSettings();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void filterList() {
    final allCategory = AppLocalizations.of(context)!.all;
    final allFrequency = AppLocalizations.of(context)!.all;

    setState(() {
      filteredList = stimuliList.where((stimuli) {
        final bool matchesCategory = selectedCategory == null ||
            selectedCategory == allCategory ||
            stimuli.categoryName == selectedCategory;
        final bool matchesFrequency = selectedFrequency == null ||
            selectedFrequency == allFrequency ||
            stimuli.frequency == int.parse(selectedFrequency!);
        return matchesCategory && matchesFrequency;
      }).toList();
    });
  }

  void resetFilters() {
    setState(() {
      selectedCategory = null;
      selectedFrequency = null;
      filteredList =
          List.from(stimuliList); // Setzt die gefilterte Liste zurück
    });
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

  Widget buildDropdownMenu<T>({
    required List<T> items,
    T? selectedValue,
    required String Function(T) getLabel,
    required void Function(T?) onChanged,
    required String? hintString,
  }) {
    return DropdownButton<T>(
      hint: hintString != null
          ? Text(
              hintString,
            )
          : null,
      value: selectedValue,
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(getLabel(item)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      AppLocalizations.of(context)!.all,
      'standard_music',
      'natural_plus',
      'natural_neg',
      'unnatural_pos',
      'unnatural_neg'
    ];
    List<String> frequencies = [
      AppLocalizations.of(context)!.all,
      '250',
      '500',
      '1000',
      '2000',
      '3000',
      '4000',
      '6000',
      '8000'
    ];

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
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildDropdownMenu<String>(
                    hintString: AppLocalizations.of(context)!.category,
                    items: categories,
                    selectedValue: selectedCategory,
                    getLabel: (category) => category,
                    onChanged: (category) {
                      selectedCategory = category;
                      filterList();
                    },
                  ),
                  buildDropdownMenu<String>(
                    hintString: AppLocalizations.of(context)!.frequency,
                    items: frequencies,
                    selectedValue: selectedFrequency,
                    getLabel: (frequency) => frequency,
                    onChanged: (frequency) {
                      selectedFrequency = frequency;
                      filterList();
                    },
                  ),
                  IconButton(
                    onPressed: resetFilters,
                    icon: const Icon(Icons.filter_alt_off_outlined),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    Stimuli stimuli = filteredList[index];
                    return AudioItem(
                      stimuli: stimuli,
                      isPlaying: playingStimuliId == stimuli.id,
                      onPlayPressed: () =>
                          playStimuli(stimuli.id!, stimuli.filename!),
                      onSetDefaultAudio: () =>
                          _setAudioAsDefault(stimuli.filename!),
                      defaultAudio: defaultAudio,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
