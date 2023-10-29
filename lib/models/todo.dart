// // ignore_for_file: depend_on_referenced_packages

// import 'package:firebase_database/firebase_database.dart';

// class Todo {
//   String? key;
//   String subject;
//   bool completed;
//   String userId;

//   Todo(this.subject, this.userId, this.completed);

//   Todo.fromSnapshot(DataSnapshot snapshot) :
//     key = snapshot.key,
//     userId = snapshot.value?["userId"],
//     subject = snapshot.value["subject"],
//     completed = snapshot.value["completed"];

//   toJson() {
//     return {
//       "userId": userId,
//       "subject": subject,
//       "completed": completed,
//     };
//   }
// }
// ignore_for_file: depend_on_referenced_packages, duplicate_ignore

import 'package:firebase_database/firebase_database.dart';

class Todo {
  String? key;
  String subject;
  bool completed;
  String userId;

  Todo(this.subject, this.userId, this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = (snapshot.value as Map<dynamic, dynamic>?)?["userId"] as String? ?? '',
    subject = (snapshot.value as Map<dynamic, dynamic>?)?["subject"] as String? ?? '',
    completed = (snapshot.value as Map<dynamic, dynamic>?)?["completed"] as bool? ?? false;

  Map<String, dynamic> toJson() {
    return {
      "userId": userId,
      "subject": subject,
      "completed": completed,
    };
  }
}
