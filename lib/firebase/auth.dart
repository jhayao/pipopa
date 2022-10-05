import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentuser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential> signInWithCredential(
      {required AuthCredential authCredential}) async {
    return await _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<void> createUserInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> phoneConfirmation(
      {required String phone,
      Function(PhoneAuthCredential credentials)? verificationCompleted,
      Function(FirebaseAuthException error)? verificationFailed,
      Function(String verificationId, int? resendToken)? onCodeSent,
      Function(String verificationId)? codeAutoRetrievalTimeout}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) {
        if (verificationCompleted != null) {
          verificationCompleted(credential);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (verificationFailed != null) {
          verificationFailed(e);
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (onCodeSent != null) {
          onCodeSent(verificationId, resendToken);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (codeAutoRetrievalTimeout != null) {
          codeAutoRetrievalTimeout(verificationId);
        }
      },
    );
  }

  Future validate(
      {required String verificationId, required String smsCode}) async {
    // Create a PhoneAuthCredential with the code
    var credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    // Sign the user in (or link) with the credential
    return await _firebaseAuth.signInWithCredential(credential);
  }
}
