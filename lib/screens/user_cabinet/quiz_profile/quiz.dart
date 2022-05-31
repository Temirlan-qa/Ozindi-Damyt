import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ozindi_damyt/screens/user_cabinet/quiz_profile/quiz_form.dart';
import 'quiz_db.dart';
import 'dart:async';

class QuizScreen extends StatefulWidget {
  final String dbName;
  QuizScreen({Key key, this.dbName}) : super(key: key);

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  User user;
  List<QuizDb> _hobbyListNew;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription<Event> _onHobbyAddedSubscription;
  StreamSubscription<Event> _onHobbyChangedSubscription;
  Query _hobbyQuery;

  @override
  void initState() {
    super.initState();

    onRefresh(FirebaseAuth.instance.currentUser);
    String user1 = user.email.toString().replaceAll(".", "-");
    print('$user1');
    _hobbyListNew = new List();
    _hobbyQuery = _database
        .reference()
        .child("user_list")
        .child(user1)
        .child('key1')
        .child('quiz_results');

    _onHobbyAddedSubscription = _hobbyQuery.onChildAdded.listen(onEntryAdded);
    _onHobbyChangedSubscription =
        _hobbyQuery.onChildChanged.listen(onEntryChanged);
  }

  onRefresh(userCred) {
    setState(() {
      user = userCred;
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _hobbyListNew.add(QuizDb.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event) {
    print('onEntryChanged');

    var oldEntry = _hobbyListNew.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _hobbyListNew[_hobbyListNew.indexOf(oldEntry)] =
          QuizDb.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.redAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuizFormScreen()),
            );
            // QuizFormScreen
          },
        ),
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                icon: new Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(null),
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  "Quiz нәтижелері",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
          elevation: 50.0,
        ),
        body: ListView.builder(
          itemCount: _hobbyListNew.length,
          itemBuilder: (context, i) {
            return hobbyItem(context, _hobbyListNew[i]);
          },
        ),
      ),
    );
  }

  Widget hobbyItem(BuildContext context, QuizDb quizDb) {
    return Stack(
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
          elevation: 10.0,
          child: SizedBox(
            height: 100.0,
            child: InkWell(
              child: Row(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25, top: 15),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.network(
                            'https://daryn.online/media/2020/10/13/qazaqstan-tarikhy-ubt.png',
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            quizDb.subject,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.black,
                              size: 21,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                quizDb.date,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.black,
                              size: 21,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                quizDb.point,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
