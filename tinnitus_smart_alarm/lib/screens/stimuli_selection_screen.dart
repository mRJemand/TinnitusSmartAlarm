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
import 'package:tinnitus_smart_alarm/screens/stimuli_decision_tree_screen.dart';
import 'package:tinnitus_smart_alarm/services/dialogs.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:tinnitus_smart_alarm/services/stimuli_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/audio_item.dart';
import 'package:tinnitus_smart_alarm/widgets/stimuli_description.dart';
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
  late final Future<void> _settingsFuture;
  late final Future<void> _stimuliFuture;
  ValueNotifier<String?> defaultAudioNotifier = ValueNotifier<String?>(null);
  ValueNotifier<String?> playingStimuliNotifier = ValueNotifier<String?>(null);

  @override
  void initState() {
    super.initState();
    _settingsFuture = _loadSettings();
    _stimuliFuture = _loadStimuliList();
  }

  Future<void> _loadStimuliList() async {
    stimuliList = [];
    filteredList = [];
    stimuliList = await stimuliManager.loadAllStimuli();
    filteredList = List.from(stimuliList);
    setState(() {});
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void playStimuli(Stimuli stimuli) async {
    // int index = filteredList.indexOf(stimuli);
    if (playingStimuliNotifier.value == stimuli.id) {
      await audioPlayer.stop();
      playingStimuliNotifier.value = null;
    } else {
      try {
        log(stimuli.filepath!);
        log(stimuli.filename!);
        await audioPlayer.play(stimuli.isIndividual!
            ? DeviceFileSource(stimuli.filepath!)
            : AssetSource(stimuli.filepath!));
        playingStimuliNotifier.value = stimuli.id;
      } on Exception catch (e) {
        log(e.toString());
        Dialogs.showErrorDialog(context, e.toString());
      }
    }
  }

  void setDefaultAudio(String filename) {
    settingsManager.setAssetAudioSetting(filename).then((_) {
      defaultAudioNotifier.value = filename;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(AppLocalizations.of(context)!.defaultAudioSaved(filename))));
    }).catchError((error) {
      // todo Handle errors here, maybe log them or show a different snackbar
      log(error);
    });
  }

  void filterList() {
    log('filter list');
    final allCategory = AppLocalizations.of(context)!.all;
    final allFrequency = AppLocalizations.of(context)!.all;
    // todo
    log(selectedCategory ?? 'keine kategorie');
    setState(() {
      filteredList = stimuliList.where((stimuli) {
        final bool matchesCategory = selectedCategory == null ||
            selectedCategory == allCategory ||
            stimuli.categoryName ==
                stimuliManager.getCategoryKeyByLocalizedName(
                    context, selectedCategory!);
        final bool matchesFrequency = selectedFrequency == null ||
            selectedFrequency == allFrequency ||
            stimuli.frequency == selectedFrequency!;
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
    defaultAudioNotifier.value =
        await settingsManager.getAssetAudioSetting() ?? '';
    setState(() {});
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

    Future<void> _showDecisionTree() async {
      log('message');
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TinnitusDecisionTreeScreen(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.stimuli),
        actions: [
          IconButton(
              onPressed: () => _showDecisionTree(),
              icon: const Icon(Icons.directions_outlined)),
          IconButton(
              onPressed: () => _showInfoSheet(),
              icon: const Icon(Icons.help_outline))
        ],
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
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
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
                        log(selectedCategory!);
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
                              onPlayPressed: () => playStimuli(stimuli),
                              onSetDefaultAudio: () =>
                                  setDefaultAudio(stimuli.filename!),
                              onDeleteStimuli: () => deleteStimuli(stimuli.id!),
                              defaultAudioNotifier: defaultAudioNotifier,
                              playingStimuliNotifier: playingStimuliNotifier,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: UniqueKey(),
        onPressed: () => _showUploadSheet(),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }

  void deleteStimuli(String id) async {
    await stimuliManager.deleteStimuli(id!);
    await _loadStimuliList();
  }

  Future<void> _showInfoSheet() async {
    final res = await showModalBottomSheet<bool>(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return StimuliDescriptionWidget();
      },
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    );
  }

  Future<void> _showUploadSheet() async {
    final res = await showModalBottomSheet<bool>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: UploadIndividualStimuli(),
          ),
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
