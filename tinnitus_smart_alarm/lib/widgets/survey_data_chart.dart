import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyDataChart extends StatefulWidget {
  @override
  _SurveyDataChartState createState() => _SurveyDataChartState();
}

class _SurveyDataChartState extends State<SurveyDataChart> {
  List<double> intenseResults = [];
  List<double> uncomfortableResults = [];
  List<double> ignorableResults = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
  }

  void fetchDataFromFirestore() {
    List<double> newIntenseResults = [];
    List<double> newUncomfortableResults = [];
    List<double> newIgnorableResults = [];
    User? currentUser = FirebaseAuth.instance.currentUser;

    FirebaseFirestore.instance
        .collection('survey_answers')
        .where('user_id', isEqualTo: currentUser!.uid)
        .orderBy('time')
        .snapshots()
        .listen((data) {
      data.docs.forEach((doc) {
        if (doc.data().containsKey('intense_result') &&
            doc.data().containsKey('uncomfortable') &&
            doc.data().containsKey('ignorable') &&
            doc.data().containsKey('ignorable')) {
          newIntenseResults.add(doc['intense_result'].toDouble());
          newUncomfortableResults.add(doc['uncomfortable'].toDouble());
          newIgnorableResults.add(doc['ignorable'].toDouble());
        }
      });

      setState(() {
        intenseResults.addAll(newIntenseResults);
        uncomfortableResults.addAll(newUncomfortableResults);
        ignorableResults.addAll(newIgnorableResults);
      });
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
              lineChartBarData(intenseResults, Colors.red, "Intensität"),
              lineChartBarData(uncomfortableResults, Colors.green, "Unbehagen"),
              lineChartBarData(
                  ignorableResults, Colors.blue, "Ignorierbarkeit"),
            ],
            lineTouchData: const LineTouchData(enabled: true),
          ),
        ),
      ),
    );
  }

  LineChartBarData lineChartBarData(
      List<double> results, Color color, String label) {
    return LineChartBarData(
      spots: [
        for (int i = 0; i < results.length; i++)
          FlSpot(i.toDouble(), results[i]),
      ],
      // isCurved: true,
      color: color,
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: true),
      belowBarData: BarAreaData(show: false),
    );
  }
}
