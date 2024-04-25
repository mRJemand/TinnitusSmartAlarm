import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreManager {
  Future<void> sendAnswersToFirestore(
      {required String stimuliName,
      required double volume,
      required double uncomfortable,
      required double easyToIgnore}) async {
    // Erhalten der aktuellen Benutzer-ID vom anonymen Firebase-Benutzer
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? 'unknown';

    // Erstellen eines neuen Dokuments in Firestore mit den Antwortdaten
    await FirebaseFirestore.instance.collection('survey_answers').add({
      'user_id': userId,
      'intense_result': volume,
      'uncomfortable': uncomfortable,
      'ignorable': easyToIgnore,
      'time': DateTime.now(),
      'stimuli': stimuliName,
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
