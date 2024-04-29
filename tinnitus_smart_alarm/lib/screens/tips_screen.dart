import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:searchable_listview/searchable_listview.dart';
import 'package:tinnitus_smart_alarm/data/stimuli_catalog.dart';
import 'package:tinnitus_smart_alarm/data/tips_catalog.dart';
import 'package:tinnitus_smart_alarm/models/stimuli.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.tips),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: renderSimpleSearchableList(),
              ),
            ),
          ],
        ),
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
          Text(AppLocalizations.of(context)!.errorWhileFetchingTips)
        ],
      ),
      initialList:
          tipsList.where((element) => element.language == language).toList(),
      filter: (p0) {
        return tipsList.where((element) {
          return element.objective.contains(p0) && element.language == language;
        }).toList();
      },
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
      inputDecoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.searchTip,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      closeKeyboardWhenScrolling: true,
    );
  }
}
