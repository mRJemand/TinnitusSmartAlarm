import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';

class TipsManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  static const String _keyFavorites = 'tipFavorites';

  // Save favorite tips to SharedPreferences
  static Future<bool> saveFavoriteTips(List<int> favorites) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(
        _keyFavorites, favorites.map((e) => e.toString()).toList());
  }

  // Load favorite tips from SharedPreferences
  static Future<List<int>> loadFavoriteTips() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favorites = prefs.getStringList(_keyFavorites);
    return favorites?.map(int.parse).toList() ?? [];
  }
}
