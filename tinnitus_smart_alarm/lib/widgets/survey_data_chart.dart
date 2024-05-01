import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tinnitus_smart_alarm/models/survey_result.dart';
import 'package:tinnitus_smart_alarm/services/firestore_manager.dart';

class SurveyDataChart extends StatefulWidget {
  @override
  _SurveyDataChartState createState() => _SurveyDataChartState();
}

class _SurveyDataChartState extends State<SurveyDataChart> {
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
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: LineChart(
          LineChartData(
            minY: 0,
            maxY: 10,
            gridData: const FlGridData(show: true),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text("Day ${value.toInt()}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold));
                    }),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (double value, TitleMeta meta) {
                      return Text("${value.toInt()}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold));
                    }),
              ),
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: true),
            lineBarsData: [
              lineChartBarData('Intensität', Colors.red),
              lineChartBarData('Unbehagen', Colors.green),
              lineChartBarData('Ignorierbarkeit', Colors.blue),
            ],
            lineTouchData: const LineTouchData(enabled: true),
          ),
        ),
      ),
    );
  }

  LineChartBarData lineChartBarData(String label, Color color) {
    List<double> results = surveyResults.map((e) {
      switch (label) {
        case 'Intensität':
          return e.intenseResult;
        case 'Unbehagen':
          return e.uncomfortable;
        case 'Ignorierbarkeit':
          return e.ignorable;
        default:
          return 0.0; // Should not happen
      }
    }).toList();

    return LineChartBarData(
      spots: [
        for (int i = 0; i < results.length; i++)
          FlSpot(i.toDouble(), results[i]),
      ],
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }
}
