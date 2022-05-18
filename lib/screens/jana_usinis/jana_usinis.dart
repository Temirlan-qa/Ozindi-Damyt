import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ozindi_damyt/drawer/drawer.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'dart:ui';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ozindi_damyt/drawer/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ozindi_damyt/screens/quiz/quiz_db.dart';
import 'package:url_launcher/url_launcher.dart';

class JanaUsinis extends StatefulWidget {
  const JanaUsinis({Key key}) : super(key: key);

  @override
  _JanaUsinisState createState() => _JanaUsinisState();
}

class _JanaUsinisState extends State<JanaUsinis> {
  final quiz = <QuizDb>[];
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Query _usinisQuery;

  @override
  void initState() {
    super.initState();

    _usinisQuery = _database.reference().child("jana_usinis");

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
        drawer: DrawerMenu(),
        appBar: AppBar(
          backgroundColor: primaryColor,
          actions: [
            /*
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        */
          ],
          title: Text('Жаңа ұсыныстар',style: TextStyle(color: Colors.black),),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        body: MyForm()
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double text = MediaQuery.textScaleFactorOf(context);
    print(width);



    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.only(right: 36, left: 36, top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Осы проектке байланысты  ',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: width/18),
            ),
            Text(
              ' жаңа ұсыныстарыңыз болса!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: width/19),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 35),
                child: _input()
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: SizedBox(
                height: 40,
                width: 150,
                child: RaisedButton(
                  color: secondaryColor,
                  hoverColor: secondaryColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: const Text(
                    'Жіберу',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    // Validate returns true if the form is valid, or false
                    // otherwise.
                    if (_formKey.currentState.validate()) {
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Validation Success!')));
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _input(){
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: TextField(
        controller: TextEditingController(),
        obscureText: false,
        style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 3)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent, width: 1)
          ),
        ),
      ),
    );
  }
}
