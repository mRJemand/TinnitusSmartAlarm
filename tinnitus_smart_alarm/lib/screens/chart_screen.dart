import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tinnitus_smart_alarm/widgets/survey_data_chart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              'Meine Daten',
            ),
            SizedBox(
              height: 400,
              child: SurveyDataChart(),
            ),
          ],
        ),
      ),
    );
  }
}
