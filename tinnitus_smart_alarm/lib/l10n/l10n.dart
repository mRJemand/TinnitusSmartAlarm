import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('de'),
  ];

  static bool contains(Locale locale) {
    return all.any((element) => element.languageCode == locale.languageCode);
  }
}
