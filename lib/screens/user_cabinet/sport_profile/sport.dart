import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ozindi_damyt/screens/user_cabinet/sport_profile/sport_form.dart';
import 'sport_db.dart';
import 'dart:async';

class SportScreen extends StatefulWidget {
  final String dbName;
  SportScreen({Key key, this.dbName}) : super(key: key);

  @override
  State<SportScreen> createState() => _SportScreenState();
}

class _SportScreenState extends State<SportScreen> {
  User user;
  List<SportDb> _hobbyListNew;
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
        .child('sport_results');

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
      _hobbyListNew.add(SportDb.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event) {
    print('onEntryChanged');

    var oldEntry = _hobbyListNew.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _hobbyListNew[_hobbyListNew.indexOf(oldEntry)] =
          SportDb.fromSnapshot(event.snapshot);
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
              MaterialPageRoute(builder: (context) => SportFormScreen()),
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
                  "Спорт нәтижелері",
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

  Widget hobbyItem(BuildContext context, SportDb sportDb) {
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
            height: MediaQuery.of(context).size.height / 8,
            child: InkWell(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.directions_run_rounded,
                              color: Colors.black,
                              size: 22,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                sportDb.type,
                                style: TextStyle(
                                  fontSize: 16,
                                  // fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.event,
                              color: Colors.black,
                              size: 21,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                sportDb.date,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: Colors.black,
                              size: 19,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Text(
                                sportDb.time,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Spacer(),
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.end,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Row(
                    //         children: [
                    //           Container(
                    //             margin: EdgeInsets.only(left: 5),
                    //             child: Text(
                    //               sportDb.step,
                    //               style: TextStyle(fontSize: 14),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
