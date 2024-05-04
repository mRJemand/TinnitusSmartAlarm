import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';

class StimuliManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Stimuli>> loadAllStimuli() async {
    List<Stimuli> defaultList = StimuliCatalog.stimuliList;
    List<Stimuli> individualList = await loadIndividualStimuli();

    if (individualList.isEmpty) {
      return defaultList;
    }
    return [...individualList, ...defaultList];
  }

  Future<List<Stimuli>> loadIndividualStimuli() async {
    final SharedPreferences prefs = await _prefs;
    final List<String>? stimuliJsonList =
        prefs.getStringList('personalizedStimuli');
    if (stimuliJsonList == null) {
      return [];
    }
    return stimuliJsonList
        .map((json) => Stimuli.fromJson(jsonDecode(json)))
        .toList();
  }

  Future<Stimuli?> loadStimuliById(int id) async {
    final List<Stimuli> stimuliList = await loadAllStimuli();
    return stimuliList.firstWhereOrNull((stimuli) => stimuli.id == id);
  }

  Future<Stimuli?> loadStimuliByFileName(String fileName) async {
    final List<Stimuli> stimuliList = await loadAllStimuli();
    return stimuliList
        .firstWhereOrNull((stimuli) => stimuli.filename == fileName);
  }

  Future<void> addStimuli(Stimuli stimuli) async {
    final SharedPreferences prefs = await _prefs;
    List<Stimuli> stimuliList = await loadAllStimuli();
    List<Stimuli> individualStimuliList = await loadIndividualStimuli();

    // Check whether the stimuli already exists to avoid duplicates
    int index = stimuliList.indexWhere((s) => s.id == stimuli.id);
    if (index == -1) {
      individualStimuliList.add(stimuli);
      List<String> encodedData =
          individualStimuliList.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList('personalizedStimuli', encodedData);
    }
  }

  Future<void> deleteStimuli(String id) async {
    final SharedPreferences prefs = await _prefs;
    List<Stimuli> individualStimuliList = await loadIndividualStimuli();

    individualStimuliList.removeWhere((stimuli) => stimuli.id == id);
    List<String> encodedData =
        individualStimuliList.map((s) => jsonEncode(s.toJson())).toList();
    await prefs.setStringList('personalizedStimuli', encodedData);
  }

  String getCategoryLocalizedName(BuildContext context, String key) {
    final loc = AppLocalizations.of(context);
    switch (key) {
      case 'standard_music':
        return loc!.standardMusic;
      case 'natural_neg':
        return loc!.naturalNeg;
      case 'natural_plus':
        return loc!.naturalPlus;
      case 'unnatural_neg':
        return loc!.unnaturalNeg;
      case 'unnatural_pos':
        return loc!.unnaturalPos;
      case 'individual':
        return loc!.individual;
      default:
        return 'Unbekannte Kategorie'; // Sicherstellen, dass Sie auch diese Übersetzung in Ihrer Lokalisierung haben
    }
  }

  String getCategoryKeyByLocalizedName(
      BuildContext context, String localizedName) {
    final loc = AppLocalizations.of(context);
    if (localizedName == loc!.standardMusic) {
      return 'standard_music';
    } else if (localizedName == loc.naturalNeg) {
      return 'natural_neg';
    } else if (localizedName == loc.naturalPlus) {
      return 'natural_plus';
    } else if (localizedName == loc.unnaturalNeg) {
      return 'unnatural_neg';
    } else if (localizedName == loc.unnaturalPos) {
      return 'unnatural_pos';
    } else if (localizedName == loc.individual) {
      return 'individual';
    } else {
      return 'unknown'; // Eine generische Rückgabe für unbekannte Kategorien
    }
  }
}
