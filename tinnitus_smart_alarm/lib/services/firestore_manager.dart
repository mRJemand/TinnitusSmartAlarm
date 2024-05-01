import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tinnitus_smart_alarm/models/survey_result.dart';

class FirestoreManager {
  Future<List<SurveyResult>> fetchDataFromFirestore() async {
    log('start fetching');
    List<SurveyResult> results = [];
    User? currentUser = FirebaseAuth.instance.currentUser;
    log(currentUser!.uid);
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('survey_answers')
          .where('user_id', isEqualTo: currentUser!.uid)
          .orderBy('date_time')
          .get();
      log('message');
      for (var doc in snapshot.docs) {
        var data = doc.data();
        log(data.entries.toString());
        if (data['intense_result'] != null &&
            data['uncomfortable'] != null &&
            data['ignorable'] != null &&
            data['date_time'] != null &&
            data['frequency'] != null &&
            data['stimuli'] != null &&
            data['user_id'] != null) {
          results.add(SurveyResult(
            dateTime: (data['date_time'] as Timestamp).toDate(),
            frequency: data['frequency'] as String,
            ignorable: (data['ignorable'] as num).toDouble(),
            intenseResult: (data['intense_result'] as num).toDouble(),
            stimuli: data['stimuli'] as String,
            uncomfortable: (data['uncomfortable'] as num).toDouble(),
            userId: data['user_id'] as String,
          ));
        }
      }
      log(results.toString());
    } on Exception catch (e) {
      log('Error fetching data: $e');
      return [];
    }
    return results;
  }

  Future<void> sendAnswersToFirestore(
      {required String stimuliName,
      required double volume,
      required double uncomfortable,
      required double easyToIgnore,
      required String? frequency}) async {
    // Erhalten der aktuellen Benutzer-ID vom anonymen Firebase-Benutzer
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? 'unknown';

    // Erstellen eines neuen Dokuments in Firestore mit den Antwortdaten
    await FirebaseFirestore.instance.collection('survey_answers').add({
      'user_id': userId,
      'intense_result': volume,
      'uncomfortable': uncomfortable,
      'ignorable': easyToIgnore,
      'date_time': DateTime.now(),
      'stimuli': stimuliName,
      'frequency': frequency
    });
  }

  Future<void> deleteCurrentUserEntries() async {
    // Get the current user's ID
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';

    // Reference to the Firestore collection
    CollectionReference surveyAnswers =
        FirebaseFirestore.instance.collection('survey_answers');

    // Query the collection for documents with the current user's ID
    QuerySnapshot querySnapshot =
        await surveyAnswers.where('user_id', isEqualTo: userId).get();

    // Iterate over the documents and delete each one
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await surveyAnswers.doc(doc.id).delete();
    }
  }
}
