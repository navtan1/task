import '../constant.dart';

class FirebaseService {
  static Future<bool> signUp({String? email, String? password}) async {
    await kFirebaseAuth
        .createUserWithEmailAndPassword(email: email!, password: password!)
        .catchError(
      (e) {
        print("ERROR ====>>>>$e");
      },
    );
    return true;
  }
}
