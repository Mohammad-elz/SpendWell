import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final _auth = FirebaseAuth.instance;

  Future<UserCredential> SignUp(String email, String password) async {
    final authResult = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  // Future<UserCredential> PsignUp(String phone) async {
  //   final authResult = await _auth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     verificationCompleted: (PhoneAuthCredential credential) {},
  //     verificationFailed: (FirebaseAuthException e) {
  //       Text('error');
  //     },
  //     codeSent: (String verificationId, int? resendToken) {
  //
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {},
  //   );
  //
  // }

  Future<UserCredential> SignIn(String email, String password) async {
    final authResult = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult;
  }

  Future <void> SignOut() async{
    await _auth.signOut();
  }

  Future<User?> getUser() async {
    var user = _auth.currentUser;
    if (user != null) {
      return user;
    }
    return null;
  }

}
