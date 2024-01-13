import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  createUser(String email, String password) async {
    bool isComplete = false;
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userData) async {
      await userData.user?.sendEmailVerification().whenComplete(() {
        isComplete = true;
      });
    });

    return isComplete;
  }

  loginUser(String email, String password) async {
    // bool? isVerified = auth.currentUser!.emailVerified;
    // print(isVerified);
    String status = '';
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
        if (value.user!.emailVerified) {
          // print('verified');
          status = 'verified';
        } else {
          // print('Not verified');
          await value.user!.sendEmailVerification();
          status = 'Not verified';
        }
      });
      return status;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }

  logoutUser() async {
    await auth.signOut();
  }

  resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (e) {
      return 'fail';
    }
  }
}
