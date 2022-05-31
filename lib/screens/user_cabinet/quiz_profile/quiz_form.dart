import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozindi_damyt/screens/user_cabinet/quiz_profile/quiz.dart';

class QuizFormScreen extends StatefulWidget {
  const QuizFormScreen({Key key}) : super(key: key);

  @override
  State<QuizFormScreen> createState() => _QuizFormScreenState();
}

class _QuizFormScreenState extends State<QuizFormScreen> {
  User user;

  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred){
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController subjectController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController pointController = TextEditingController();
    TextEditingController stepController = TextEditingController();
    DatabaseReference ref = FirebaseDatabase.instance.reference();

    return Scaffold(
      appBar: AppBar(
        iconTheme: (IconThemeData(color: Colors.black)),
        title: Text(
          'Quiz нәтижелерін толтыру',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[], //<Widget>[]
        backgroundColor: Colors.white,
        elevation: 50.0,
        //IconButton
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Сабақ пәнін таңда',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: subjectController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  // border: OutlineInputBorder(),
                  // labelText: 'Сабақ пәнін таңда',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Quiz-ды тапсырған күні',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  // border: OutlineInputBorder(),
                  // labelText: 'Уақытын таңда',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Сіздің алған ұпайыңыз',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: pointController,
                decoration: InputDecoration(
                  // border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  // labelText: 'Ұпайдың саны',
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Text(
              //     'Қосымша ақпарат',
              //     style: TextStyle(
              //       fontSize: 16,
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // TextField(
              //   controller: stepController,
              //   decoration: InputDecoration(
              //     // border: OutlineInputBorder(),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.redAccent,
              //       ),
              //     ),
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.redAccent,
              //       ),
              //     ),
              //     // labelText: 'Ұпайдың саны',
              //   ),
              // ),
              SizedBox(
                height: 50,
              ),
              OutlineButton(
                onPressed: () async {
                  await ref.child('user_list').child("${user.email.replaceAll(".", "-")}").child('key1').child('quiz_results').push().update({
                    "subject": subjectController.text,
                    "date": dateController.text,
                    "point": pointController.text,
                    // "step":stepController.text,
                  });
                  Navigator.of(context).pop(null);
                },
                color: Colors.redAccent,
                child: Text('Сақтау'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
