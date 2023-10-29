// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_new, sort_child_properties_last, prefer_const_literals_to_create_immutables, annotate_overrides, avoid_print

import 'package:flutter/material.dart';
import 'package:major_app/services/authentication.dart';

/*import 'package:qr_flutter/qr_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';*/

import 'teach_tab1_page.dart';
import 'teach_tab2_page.dart';

class TeacherHomePage extends StatefulWidget {
  TeacherHomePage(
      {required Key key,
      required this.auth,
      required this.userId,
      required this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;

  final String userId;

  @override
  State<StatefulWidget> createState() => new _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  //final FirebaseDatabase _database = FirebaseDatabase.instance;

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.arrow_drop_down),
                  text: "Take Attendance",
                ),
                Tab(icon: Icon(Icons.book), text: "View Records"),
              ],
            ),
            title: Text(
              ' Welcome Teacher',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.pinkAccent,
            actions: <Widget>[
              new TextButton(
                  child: new Text('Logout',
                      style: new TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  onPressed: signOut),
            ],
          ),
          body: TabBarView(
            children: [
              TeacherBasicPage(),//ama parameter compulsory pass karva padse,, to kari dav?ha,, 
              // khali call karvana ne? nam lakhi ne // na e parameter ni value pass karvani 
              TeacherBasicSecPage(key: null,),//aa be eerror aave chhe null v
            ],
          ),
        ),
      ),
    );
  }
}
