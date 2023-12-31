// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';

// abstract class BaseAuth {
//   Future<String> signIn(String email, String password);

//   Future<String> signUp(String email, String password); //sign up method nu

//   Future<User> getCurrentUser();

//   Future<void> sendEmailVerification();//nu

//   Future<void> signOut();

//   Future<bool> isEmailVerified(); //nu
// }

// class Auth implements BaseAuth {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   Future<String> signIn(String email, String password) async {
//     UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
//         email: email, password: password);
//     User? user = result.user;
//     return user!.uid;
//   }

//  Future<String> signUp(String email, String password) async {
//     UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
//         email: email, password: password);
//     User? user = result.user;
//     return user!.uid;
//   }

//   @override
//   Future<User?> getCurrentUser() async {
//     User? user = await _firebaseAuth.currentUser;
//     return user;
//   }

//   Future<void> signOut() async {
//     return _firebaseAuth.signOut();
//   }

//   Future<void> sendEmailVerification() async {
//     User user = await _firebaseAuth.currentUser!;
//     user.sendEmailVerification();
//   }

//   Future<bool> isEmailVerified() async {
//     User user = await _firebaseAuth.currentUser!;
//     return user.isEmailVerified;
  
//   }
  
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<User?> getCurrentUser(); // Modify to User? type

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signIn(String email, String password) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user!.uid;
  }

  @override
  Future<String> signUp(String email, String password) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    User? user = result.user;
    return user!.uid;
  }

  @override
  Future<User?> getCurrentUser() async {
    User? user = _firebaseAuth.currentUser;
    return user;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<void> sendEmailVerification() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }

  @override
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.reload();
      return user.emailVerified;
    } else {
      return false;
    }
  }
}
