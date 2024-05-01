import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tinnitus_smart_alarm/models/survey_result.dart';
import 'package:tinnitus_smart_alarm/services/firestore_manager.dart';
import 'package:tinnitus_smart_alarm/widgets/survey_data_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChartScreen extends StatefulWidget {
  const ChartScreen({super.key});

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<SurveyResult> surveyResults = [];

  FirestoreManager firestoreManager = FirestoreManager();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var results = await firestoreManager.fetchDataFromFirestore();
    setState(() {
      surveyResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.myData),
            SizedBox(
              height: 800,
              child: SurveyDataChart(
                surveyResults: surveyResults,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
