import 'package:cloud_firestore/cloud_firestore.dart';

class SurveyResult {
  DateTime dateTime;
  String frequency;
  double ignorable;
  double intenseResult;
  String stimuli;
  double uncomfortable;
  String userId;

  SurveyResult({
    required this.dateTime,
    required this.frequency,
    required this.ignorable,
    required this.intenseResult,
    required this.stimuli,
    required this.uncomfortable,
    required this.userId,
  });

  factory SurveyResult.fromFirestore(Map<String, dynamic> data) {
    return SurveyResult(
      dateTime: (data['date_time'] as Timestamp).toDate(),
      frequency: data['frequency'] as String,
      ignorable: (data['ignorable'] as num).toDouble(),
      intenseResult: (data['intense_result'] as num).toDouble(),
      stimuli: data['stimuli'] as String,
      uncomfortable: (data['uncomfortable'] as num).toDouble(),
      userId: data['user_id'] as String,
    );
  }
}
