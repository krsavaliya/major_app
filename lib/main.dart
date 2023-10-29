// ignore_for_file: unnecessary_new, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/register_page.dart';

Future<void> main() async {
   await Firebase.initializeApp(); //firebase done
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.pink,
            // ignore: prefer_const_constructors
            title: Text(
              "Smart Attendance",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: Registration()),
    );
  }
}
