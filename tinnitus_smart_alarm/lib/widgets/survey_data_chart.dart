import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tinnitus_smart_alarm/models/survey_result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SurveyDataChart extends StatefulWidget {
  final List<SurveyResult> surveyResults;

  SurveyDataChart({Key? key, required this.surveyResults}) : super(key: key);

  @override
  _SurveyDataChartState createState() => _SurveyDataChartState();
}

class _SurveyDataChartState extends State<SurveyDataChart> {
  SurveyResult? selectedResult;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 400,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: widget.surveyResults.length.toDouble(),
                minY: 0,
                maxY: 10,
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(),
                  topTitles: AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        final index = value.toInt();
                        if (index < widget.surveyResults.length) {
                          return Text(
                            DateFormat('dd.MM')
                                .format(widget.surveyResults[index].dateTime),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) =>
                          Text(value.toInt().toString()),
                    ),
                  ),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.surveyResults
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.intenseResult))
                        .toList(),
                    isCurved: false,
                    color: Colors.red,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    // belowBarData: BarAreaData(show: true),
                  ),
                  LineChartBarData(
                    spots: widget.surveyResults
                        .asMap()
                        .entries
                        .map((entry) =>
                            FlSpot(entry.key.toDouble(), entry.value.ignorable))
                        .toList(),
                    isCurved: false,
                    color: Colors.blue,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    // belowBarData: BarAreaData(show: true),
                  ),
                  LineChartBarData(
                    spots: widget.surveyResults
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                            entry.key.toDouble(), entry.value.uncomfortable))
                        .toList(),
                    isCurved: false,
                    color: Colors.green,
                    barWidth: 5,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    // belowBarData: BarAreaData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (event is FlTapUpEvent && touchResponse != null) {
                      final index = touchResponse.lineBarSpots?.first.x.toInt();
                      if (index != null &&
                          index >= 0 &&
                          index < widget.surveyResults.length) {
                        setState(() {
                          selectedResult = widget.surveyResults[index];
                        });
                      }
                    }
                  },
                  handleBuiltInTouches: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((LineBarSpot spot) {
                        String tooltipText = '';
                        if (spot.barIndex == 0) {
                          tooltipText =
                              '${AppLocalizations.of(context)!.intense}: ${spot.y.toStringAsFixed(2)}';
                        } else if (spot.barIndex == 1) {
                          tooltipText =
                              '${AppLocalizations.of(context)!.ignorable}: ${spot.y.toStringAsFixed(2)}';
                        } else if (spot.barIndex == 2) {
                          tooltipText =
                              '${AppLocalizations.of(context)!.uncomfortable}: ${spot.y.toStringAsFixed(2)}';
                        }
                        return LineTooltipItem(
                          tooltipText,
                          TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (selectedResult != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppLocalizations.of(context)!.time}: ${DateFormat('dd.MM.yyyy HH:mm').format(selectedResult!.dateTime)}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.intense}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: selectedResult!.intenseResult,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: null, // Disable slider interaction
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.ignorable}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: selectedResult!.ignorable,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: null, // Disable slider interaction
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.uncomfortable}:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: selectedResult!.uncomfortable,
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: null, // Disable slider interaction
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.stimuli}: ${selectedResult!.stimuli}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${AppLocalizations.of(context)!.frequency}: ${selectedResult!.frequency}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
