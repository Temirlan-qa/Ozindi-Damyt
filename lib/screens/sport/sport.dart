import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ozindi_damyt/drawer/drawer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:ozindi_damyt/screens/sport/sport_db.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SportPage extends StatefulWidget {
  final String dbName;
  const SportPage({Key key, this.dbName}) : super(key: key);

  @override
  _SportPageState createState() => _SportPageState();
}

class _SportPageState extends State<SportPage> {
  final sport = <SportDb>[];
  List<SportDb> _sportListNew;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  StreamSubscription<Event> _onSportAddedSubscription;
  StreamSubscription<Event> _onSportChangedSubscription;
  Query _sportQuery;

  @override
  void initState() {
    super.initState();

    _sportListNew = new List();
    _sportQuery = _database.reference().child("sports");

    _onSportAddedSubscription = _sportQuery.onChildAdded.listen(onEntryAdded);
    _onSportChangedSubscription =
        _sportQuery.onChildChanged.listen(onEntryChanged);
  }

  onEntryAdded(Event event) {
    setState(() {
      _sportListNew.add(SportDb.fromSnapshot(event.snapshot));
    });
  }

  onEntryChanged(Event event) {
    print('onEntryChanged');

    var oldEntry = _sportListNew.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _sportListNew[_sportListNew.indexOf(oldEntry)] =
          SportDb.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerMenu(),
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: [
          /*
          IconButton(icon: Icon(Icons.search), onPressed: () {})
          */
        ],
        title: Text('Спорт',style: TextStyle(color: Colors.black),),
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
      body: ListView.builder(
          itemCount: _sportListNew.length,
          itemBuilder: (context, i) {
            return sportItem(context, _sportListNew[i]);
          }),
    );
  }

  Widget sportItem(BuildContext context, SportDb sportDb) {
    Size size=MediaQuery.of(context).size;
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    double text=MediaQuery.textScaleFactorOf(context);
    print(width);
    return Container(
      // height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          GestureDetector(
            onTap: () async {
              final url = sportDb.link;
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 10,right: 10,bottom: 5,top: 5),
              child: Container(
                // width: MediaQuery.of(context).size.width,

                child: Center(
                  child: Card(
                    elevation: 15,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(6),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                          image: DecorationImage(
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.2),
                                BlendMode.srcOver),
                            fit: BoxFit.cover,
                            image: NetworkImage(sportDb.photo),
                          ),
                        ),
                        child: Container(
                            height: width/3,
                            width: MediaQuery.of(context).size.width,
                            child: Padding(
                              padding: EdgeInsets.only(top: 6, left: 15),
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: 20, left: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      sportDb.title,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Comfortaa',
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(bottom: 5),
                                      width:
                                          MediaQuery.of(context).size.width / 2,
                                      child: Text(
                                        sportDb.desc,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
