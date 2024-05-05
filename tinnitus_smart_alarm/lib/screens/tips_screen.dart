import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:tinnitus_smart_alarm/data/tips_catalog.dart';
import 'package:tinnitus_smart_alarm/models/tip.dart';
import 'package:tinnitus_smart_alarm/services/settings_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/tip_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  List<Tip> tipsList = [];
  final TextEditingController searchTextController = TextEditingController();
  final SettingsManager settingsManager = SettingsManager();
  bool showFavoritesOnly = false;
  String language = '';

  @override
  void initState() {
    super.initState();
    tipsList = TipsCatalag.tipsList;
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    language = await settingsManager.getLocaleSetting();
    setState(() {});
  }

  void _toggleFavorites() {
    setState(() {
      showFavoritesOnly = !showFavoritesOnly;
    });
  }

  List<Tip> _getFilteredTips(String searchText) {
    return tipsList.where((tip) {
      final matchesLanguage = tip.language == language;
      final matchesText =
          tip.objective.toLowerCase().contains(searchText.toLowerCase()) ||
              tip.title.toLowerCase().contains(searchText.toLowerCase()) ||
              tip.explanation.toLowerCase().contains(searchText.toLowerCase());
      final matchesFavorites = !showFavoritesOnly ||
          (tip.isFavorite == null ? false : tip.isFavorite!);

      return matchesLanguage && matchesText && matchesFavorites;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tips),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: renderSimpleSearchableList(),
      ),
    );
  }

  Widget renderSimpleSearchableList() {
    return SearchableList<Tip>(
      displayClearIcon: true,
      searchTextController: searchTextController,
      builder: (list, index, item) {
        return TipItem(tip: item);
      },
      inputDecoration: InputDecoration(
        prefixIcon: IconButton(
          icon: Icon(
            showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
            color: showFavoritesOnly ? Colors.red : null,
          ),
          onPressed: () {
            _toggleFavorites();
            searchTextController.text = searchTextController.text;
          },
        ),
      ),
      errorWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(AppLocalizations.of(context)!.errorWhileFetchingTips),
        ],
      ),
      initialList: _getFilteredTips(''),
      filter: _getFilteredTips,
      emptyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          Text(AppLocalizations.of(context)!.noTipsFound),
        ],
      ),
      onRefresh: () async {},
      onItemSelected: (Tip item) {},
      closeKeyboardWhenScrolling: true,
    );
  }
}
