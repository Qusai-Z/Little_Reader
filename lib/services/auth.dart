import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future Anonymous_SignIn() async {
    try {
      UserCredential newUser = await _auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }

// Sign out function

}
