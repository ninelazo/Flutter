import 'package:firebase_auth/firebase_auth.dart';
import 'package:servicio/main.dart';

class FirebaseAuthService{
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?>? signUpWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    // ignore: empty_catches
    } catch (e) {

    }
    return null;
  }

  Future<User?>? signInWithEmailAndPassword(String email, String password) async {
    try{
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    // ignore: empty_catches
    } catch (e) {

    }
    return null;
  }

}