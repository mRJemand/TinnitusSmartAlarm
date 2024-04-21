import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
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
  final SettingsManager settingsManager = SettingsManager();
  late final Future<void> _settingsFuture;
  late String defaultAudio;

  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  bool _isLoading = false;
  bool _userAborted = false;

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

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      // _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      // _userAborted = false;
    });
  }

  // Future<void> _saveFile() async {
  //   _resetState();
  //   try {
  //     String? fileName = await FilePicker.platform.saveFile(
  //       // allowedExtensions: (_extension?.isNotEmpty ?? false)
  //       //     ? _extension?.replaceAll(' ', '').split(',')
  //       //     : null,
  //       // type: _pickingType,
  //       dialogTitle: _dialogTitleController.text,
  //       fileName: _defaultFileNameController.text,
  //       initialDirectory: _initialDirectoryController.text,
  //       lockParentWindow: _lockParentWindow,
  //     );
  //     setState(() {
  //       _saveAsFileName = fileName;
  //       _userAborted = fileName == null;
  //     });
  //   } on PlatformException catch (e) {
  //     _logException('Unsupported operation' + e.toString());
  //   } catch (e) {
  //     _logException(e.toString());
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  void _pickFiles() async {
    _resetState();
    try {
      _directoryPath = null;
      _paths = (await FilePicker.platform.pickFiles(
        // compressionQuality: 30,
        type: FileType.audio,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        // allowedExtensions: (_extension?.isNotEmpty ?? false)
        //     ? _extension?.replaceAll(' ', '').split(',')
        //     : null,
        // dialogTitle: '_dialogTitleController',
        // initialDirectory: _initialDirectoryController.text,
        // lockParentWindow: _lockParentWindow,
      ))
          ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e) {
      _logException(e.toString());
    }
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _fileName =
          _paths != null ? _paths!.map((e) => e.name).toString() : '...';
      _userAborted = _paths == null;
      _logException('Uploaded File: $_fileName');
    });
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
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          _pickFiles();
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
