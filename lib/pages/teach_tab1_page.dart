// ignore_for_file: prefer_const_constructors, unnecessary_new, await_only_futures, prefer_interpolation_to_compose_strings, curly_braces_in_flow_control_structures, use_build_context_synchronously, prefer_const_constructors_in_immutables, avoid_print, sized_box_for_whitespace

import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as ency;
import 'package:major_app/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherBasicPage extends StatefulWidget {
  TeacherBasicPage(
      {required key,
      required this.auth,
      required this.userId,
      required this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;

  final String userId;

  @override
  State<StatefulWidget> createState() => new _TeacherBasicPageState();
}

class _TeacherBasicPageState extends State<TeacherBasicPage> {
  //final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  //bool _isEmailVerified = false;
  late String classname;
  late String date;
  late String secretcode;
  late String check;
  late String str;
  String userId = '';
  String saveMessage = 'Click save to update or cancel to reject';

  bool validateAndSave() {
    final form = _formKey1.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    userId = widget.userId;
    super.initState();
    //_checkEmailVerification();
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            /*ConstrainedBox(
            constraints: new BoxConstraints(
              minHeight: 500,
              minWidth: 300,
              maxHeight: 700,
              maxWidth: 500,
            ),*/
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        enterDetails(),
                        formInput(),
                        GestureDetector(
                          onTap: () {
                            showCustomDialogWithImage(context);
                          },
                          child: Container(
                            margin: EdgeInsets.all(70),
                            width: 300,
                            height: 40,
                            //color:Colors.pink,
                            decoration: BoxDecoration(
                                color: Colors.pink,
                                shape: BoxShape.rectangle,
                                //borderRadius: BorderRadius.circular(10),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25))),

                            child: const Center(
                              child: Text(
                                'Generate QR Code',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget formInput() {
    return new Form(
      key: _formKey1,
      child: new ListView(
        shrinkWrap: true,
        children: <Widget>[
          subjCodeInput(),
          dateInput(),
          checkInput(),
          codeInput(),
        ],
      ),
    );
  }

  Widget enterDetails() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        width: 280,
        height: 50,
        alignment: Alignment(80, 30),
        decoration: BoxDecoration(
          color: Colors.pink,
          shape: BoxShape.rectangle,
          //borderRadius: BorderRadius.circular(12),
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: const Center(
          child: Text(
            'Enter Details',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget checkInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 5.0),
      child: new TextFormField(
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          hintText: 'Enter no of classes for the day',
        ),
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) => value!.isEmpty ? 'Enter classes first' : null,
        onSaved: (value) => check = value!.trim(),
      ),
    );
  }

  Widget subjCodeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 5.0),
      child: new TextFormField(
        maxLines: 1,
        textAlign: TextAlign.center,
        decoration: new InputDecoration(
          hintText: 'Enter subject code',
        ),
        keyboardType: TextInputType.text,
        autofocus: false,
        validator: (value) =>
            value!.isEmpty ? 'Enter subject code first' : null,
        onSaved: (value) => classname = value!.trim(),
      ),
    );
  }

  Widget dateInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        decoration: new InputDecoration(
          hintText: 'Enter date in dd.mm.yy format',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.datetime,
        autofocus: false,
        validator: (value) =>
            value!.isEmpty ? 'Enter date in dd.mm.yy format' : null,
        onSaved: (value) => date = value!.trim(),
      ),
    );
  }

  Widget codeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        decoration: new InputDecoration(
          hintText: 'Enter your code',
        ),
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        autofocus: false,
        validator: (value) =>
            value!.isEmpty || value.contains('.') || value.contains(' ')
                ? 'Code cant be empty or have spaces and dots'
                : null,
        onSaved: (value) => secretcode = value!.trim(),
      ),
    );
  }

  Future<void> showCustomDialogWithImage(BuildContext context) async {
    if (validateAndSave()) {
      //print(userId);
      var firebaseUser = await FirebaseAuth.instance.currentUser!;
      String qrData = classname +
          '/' +
          date +
          '/' +
          check +
          '/' +
          secretcode +
          '/' +
          firebaseUser.uid;

      final key = ency.Key.fromUtf8('JingalalahuhuJingalalahuhuJingal');
      final iv = ency.IV.fromLength(16);
      final encrypter = ency.Encrypter(ency.AES(key));
      final encryptedQR = encrypter.encrypt(qrData, iv: iv);
      final decryptedQR =
          encrypter.decrypt(encryptedQR, iv: iv); //used in student's home page

      print(qrData);
      print(encryptedQR.base64);
      print(decryptedQR);
      print(encryptedQR.base64);

      Dialog dialogWithImage = Dialog(
        child: Container(
          height: 330.0,
          width: 300.0,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                child: Container(
                  height: 200,
                  width: 300,
                  child: Center(
                    child: Image(
                      image: MemoryImage(encryptedQR.base64 as Uint8List),
                      width: 200.0,
                      height: 200.0,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey, // Background color
                    ),
                    onPressed: () {
                      saveTheForm(qrData);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey, // Background color
                    ),
                    onPressed: () {
                      setState(() {
                        saveMessage =
                            'Click save to update or cancel to reject';
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(saveMessage)
            ],
          ),
        ),
      );
      showDialog(
          context: context,
          builder: (BuildContext context) => dialogWithImage,
          barrierDismissible: false);
    }
  }

  void showCustomDialog(BuildContext context, String msg, String msg1) {
    AlertDialog dialogWithImage = AlertDialog(
      title: Text(msg1),
      content: Text(msg),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          child:
              Text('OK', style: TextStyle(fontSize: 18.0, color: Colors.blue)),
        ),
      ],
      elevation: 24.0,
    );
    showDialog(
        context: context,
        builder: (BuildContext context) => dialogWithImage,
        barrierDismissible: false);
  }

  Future<void> saveTheForm(String qrData) async {
    final firestoreInstance = FirebaseFirestore.instance;
    var qrDetails = qrData.split('/');
    var classname = qrDetails[0];
    var dates = qrDetails[1].split('.');
    var day = dates[0];
    var date = dates[1] + '.' + dates[2];
    var secretCode = qrDetails[3];
    var exists = 0;
    var codeExists = 0;
    var updatedData = [];
    //print(docs);
    var firebaseUser = await FirebaseAuth.instance.currentUser!;

    final CollectionReference monthsRef = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid)
        .collection(classname);

    var monthsDocs = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .collection(classname)
        .get();

    var months = monthsDocs.docs;

    for (int i = 0; i < months.length; i++)
      if (date == months[i].id) {
        exists = 1;
        break;
      }

    if (exists == 0) await monthsRef.doc(date).set({});

    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseUser.uid)
        .collection(classname)
        .doc(date)
        .get();

    //print(data[day]['codes'][0]);

    try {
      for (int i = 0; i < data[day]['codes'].length; i++)
        if (data[day]['codes'][i] == secretCode) {
          codeExists = 1;
          break;
        }
    } catch (e) {
      print("Caught");
    }

    print(codeExists);
    if (codeExists == 1) {
      Navigator.of(context, rootNavigator: true).pop();
      showCustomDialog(
          context, 'Secret code already exists.Please enter a new one', 'Oops');
    } else {
      try {
        updatedData = data[day]['codes'] + [secretCode];
      } catch (e) {
        updatedData = [secretCode];
      }

      try {
        firestoreInstance
            .collection("users")
            .doc(firebaseUser.uid)
            .collection(classname)
            .doc(date)
            .update({
          "$day.codes": updatedData,
        });
        // Navigator.of(context, rootNavigator: true).pop();
        showCustomDialog(
            context, 'QR Saved and ready to be scanned', 'Success');
      } catch (e) {
        showCustomDialog(context, 'Update Failed,Please try again', 'Error');
        print(e.toString());
      }
    }
  }
}
