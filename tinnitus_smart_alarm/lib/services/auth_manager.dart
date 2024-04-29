import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthManager {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> checkAndSignInAnonymously() async {
    User? user = _auth.currentUser;

    if (user == null) {
      user = (await _auth.signInAnonymously()).user;
      log("Logged in with a temporary account: ${user!.uid}");
    } else {
      log("User is already logged in with UID: ${user.uid}");
    }
  }

  // Funktion, um sich abzumelden und das Konto zu löschen
  Future<void> signOutAndDeleteAccount() async {
    User? user = _auth.currentUser;

    if (user != null && user.isAnonymous) {
      try {
        await user.delete();
        log("Anonymous account has been deleted.");
      } catch (e) {
        log("Error when deleting the account: $e");
      }
    } else {
      log("No logged in user found or the user is not anonymous.");
    }
    await checkAndSignInAnonymously();
  }
}
