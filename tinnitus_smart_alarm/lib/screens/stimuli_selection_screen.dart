import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/audio_item.dart';
import 'package:tinnitus_smart_alarm/widgets/upload_individual_stimuli.dart';

class StimuliSelectionScreen extends StatefulWidget {
  const StimuliSelectionScreen({super.key});

  @override
  State<StimuliSelectionScreen> createState() => _StimuliSelectionScreenState();
}

class _StimuliSelectionScreenState extends State<StimuliSelectionScreen> {
  final SettingsManager settingsManager = SettingsManager();
  final StimuliManager stimuliManager = StimuliManager();
  List<Stimuli> stimuliList = [];
  List<Stimuli> filteredList = [];
  String? selectedCategory;
  String? selectedFrequency;
  final AudioPlayer audioPlayer = AudioPlayer();
  String? playingStimuliId;
  late final Future<void> _settingsFuture;
  late final Future<void> _stimuliFuture;
  late String defaultAudio;

  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  Map<String, int> alphabetIndex = {};

  void playStimuli(Stimuli stimuli) async {
    if (playingStimuliId == stimuli.id) {
      await audioPlayer.stop();
      setState(() => playingStimuliId = null);
    } else {
      if (stimuli.isIndividual ?? false) {
        await audioPlayer.play(DeviceFileSource(stimuli.filepath!));
      } else {
        log('Try to play: ${stimuli.filename}');
        await audioPlayer.play(AssetSource('${stimuli.filepath}'));
      }
      setState(() => playingStimuliId = stimuli.id);
    }
  }

  @override
  void initState() {
    super.initState();
    _settingsFuture = _loadSettings();
    _stimuliFuture = _loadStimuliList();
    createAlphabetIndex();
  }

  Future<void> _loadStimuliList() async {
    stimuliList = await stimuliManager.loadAllStimuli();
    filteredList = List.from(stimuliList);
    setState(() {});
    log("MYLIST;");
    log(stimuliList.length.toString());
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void createAlphabetIndex() {
    alphabetIndex.clear();
    for (int i = 0; i < filteredList.length; i++) {
      if (filteredList[i].filename != null) {
        String firstLetter =
            filteredList[i].filename!.substring(0, 1).toUpperCase();
        if (!alphabetIndex.containsKey(firstLetter)) {
          alphabetIndex[firstLetter] = i;
        }
      }
    }
  }

  void scrollToIndex(String letter) {
    if (alphabetIndex.containsKey(letter)) {
      itemScrollController.jumpTo(index: alphabetIndex[letter]!, alignment: 0);
    }
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
            stimuli.frequency == selectedFrequency!;
        return matchesCategory && matchesFrequency;
      }).toList();

      createAlphabetIndex();
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
    defaultAudio = await settingsManager.getAssetAudioSetting() ?? '';
    setState(() {});
  }

  _setAudioAsDefault(String filename) {
    settingsManager.setAssetAudioSetting(filename);
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

  void _logException(String message) {
    print(message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      AppLocalizations.of(context)!.all,
      stimuliManager.getCategoryLocalizedName(context, 'standard_music'),
      stimuliManager.getCategoryLocalizedName(context, 'natural_plus'),
      stimuliManager.getCategoryLocalizedName(context, 'natural_neg'),
      stimuliManager.getCategoryLocalizedName(context, 'unnatural_pos'),
      stimuliManager.getCategoryLocalizedName(context, 'unnatural_neg'),
      stimuliManager.getCategoryLocalizedName(context, 'individual')
    ];
    final List<String> frequencies = [
      '250 Hz',
      '500 Hz',
      '1000 Hz',
      '2000 Hz',
      '3000 Hz',
      '4000 Hz',
      '6000 Hz',
      '8000 Hz'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stimuli),
      ),
      body: FutureBuilder(
        future: Future.wait([_settingsFuture, _stimuliFuture]),
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
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: ScrollablePositionedList.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          Stimuli stimuli = filteredList[index];
                          return AudioItem(
                            stimuli: stimuli,
                            isPlaying: playingStimuliId == stimuli.id,
                            onPlayPressed: () => playStimuli(stimuli),
                            onSetDefaultAudio: () =>
                                _setAudioAsDefault(stimuli.filename!),
                            defaultAudio: defaultAudio,
                          );
                        },
                        itemScrollController: itemScrollController,
                        itemPositionsListener: itemPositionsListener,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        26,
                        (index) {
                          String letter = String.fromCharCode(65 + index);
                          bool isActive = alphabetIndex.containsKey(letter);
                          return GestureDetector(
                            onTap:
                                isActive ? () => scrollToIndex(letter) : null,
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Text(
                                letter,
                                style: TextStyle(
                                  color: isActive ? Colors.black : Colors.grey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () => _showUploadSheet(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  Future<void> _showUploadSheet() async {
    final res = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: const UploadIndividualStimuli(),
        );
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
    if (res != null && res) {
      await _loadStimuliList();
      setState(() {});
    }
  }
}
