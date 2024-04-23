import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';

class StimuliManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<Stimuli>> loadAllStimuli() async {
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

  Future<void> addStimuli(Stimuli stimuli) async {
    final SharedPreferences prefs = await _prefs;
    List<Stimuli> stimuliList = await loadAllStimuli();
    // Check whether the stimuli already exists to avoid duplicates
    int index = stimuliList.indexWhere((s) => s.id == stimuli.id);
    if (index == -1) {
      stimuliList.add(stimuli);
      List<String> encodedData =
          stimuliList.map((s) => jsonEncode(s.toJson())).toList();
      await prefs.setStringList('personalizedStimuli', encodedData);
    }
  }

  Future<void> deleteStimuli(int id) async {
    final SharedPreferences prefs = await _prefs;
    List<Stimuli> stimuliList = await loadAllStimuli();
    stimuliList.removeWhere((stimuli) => stimuli.id == id);
    List<String> encodedData =
        stimuliList.map((s) => jsonEncode(s.toJson())).toList();
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
}
