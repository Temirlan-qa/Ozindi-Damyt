import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

import 'package:ozindi_damyt/screens/kitapkhana/book.dart';

class UserBooks extends StatefulWidget {
  @override
  UserBooksState createState() => UserBooksState();
}

class UserBooksState extends State<UserBooks> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String userEmail = "user@gmail.com", firebaseEmailConverted, currentUserKey;
  Query _currentUserQuery;
  List<Book> _bookList;
  Book book;

  @override
  void initState() {
    super.initState();

    User currentUser = auth.currentUser;
    _bookList = new List();

    if (currentUser != null) {
      setState(() {
        userEmail = currentUser.email;
      });

      firebaseEmailConverted = userEmail.replaceAll('.', "-");

      _currentUserQuery = _database
          .reference()
          .child("user_list")
          .child(firebaseEmailConverted);

      _currentUserQuery.onChildAdded.listen(onEntryAdded);
    }
  }

  onEntryAdded2(Event event) {
    setState(() {
      _bookList.add(Book.fromFinishedBooks(event.snapshot));
      print(_bookList.length);
    });
  }

  onEntryAdded(Event event) {
    _currentUserQuery.once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          currentUserKey = key;

          if (values["readBooks"] != null) {
            values["readBooks"].forEach((key, values) {
              book = new Book(
                  name: values["name"],
                  author: values["author"],
                  photo: values["photo"],
                  date: values["date"]);
              print('${book.name}');

              setState(() {
                _bookList.add(book);
              });
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: Colors.white,
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
                      "Кітаптар",
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
            actions: <Widget>[
              //IconButton
              //IconButton
            ], //<Widget>[]
            backgroundColor: Colors.white,
            elevation: 50.0,
            //IconButton
          ),
          body: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Container(
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: 160,
                  //     child: RaisedButton(
                  //       elevation: 10.0,
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(5)),
                  //       highlightElevation: 20.0,
                  //       hoverColor: Colors.white,
                  //       color: Colors.white,
                  //       child: SingleChildScrollView(
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Container(
                  //               child: Text('Оқылған',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 15))
                  //             ),
                  //             Container(
                  //               child: Text('кітаптар',
                  //                 style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   fontSize: 15))
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       textColor: Colors.black,
                  //       disabledTextColor: Colors.black,
                  //       disabledColor: Colors.grey,
                  //       onPressed: () {
                  //       }
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   child: SizedBox(
                  //     height: 50,
                  //     width: 160,
                  //     child: RaisedButton(
                  //         elevation: 10.0,
                  //         shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(5)),
                  //         highlightElevation: 20.0,
                  //         hoverColor: Colors.white,
                  //         color: Colors.white,
                  //         child: SingleChildScrollView(
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                   child: SingleChildScrollView(
                  //                       scrollDirection: Axis.vertical,
                  //                       child: Text('Оқылған',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 15)))),
                  //               Container(
                  //                   child: SingleChildScrollView(
                  //                       scrollDirection: Axis.vertical,
                  //                       child: Text('әңгімелер',
                  //                           style: TextStyle(
                  //                               fontWeight: FontWeight.bold,
                  //                               fontSize: 15)))),
                  //             ],
                  //           ),
                  //         ),
                  //         textColor: Colors.black,
                  //         disabledTextColor: Colors.black,
                  //         disabledColor: Colors.grey,
                  //         onPressed: () {}),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(child: Container(child: finishedBookList(context))),
          ])

          // Stack(
          //   children: [
          //     ListView(
          //       children: <Widget>[
          //         Container(
          //           margin: EdgeInsets.only(top: 20),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               Container(
          //                 child: SizedBox(
          //                   height: 50,
          //                   width: 160,
          //                   child: RaisedButton(
          //                       elevation: 10.0,
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(5)),
          //                       highlightElevation: 20.0,
          //                       hoverColor: Colors.white,
          //                       color: Colors.white,
          //                       child: SingleChildScrollView(
          //                         child: Column(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Container(
          //                                 child: Text('Оқылған',
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold,
          //                                         fontSize: 15))),
          //                             Container(
          //                                 child: Text('кітаптар',
          //                                     style: TextStyle(
          //                                         fontWeight: FontWeight.bold,
          //                                         fontSize: 15))),
          //                           ],
          //                         ),
          //                       ),
          //                       textColor: Colors.black,
          //                       disabledTextColor: Colors.black,
          //                       disabledColor: Colors.grey,
          //                       onPressed: () {}),
          //                 ),
          //               ),
          //               Container(
          //                 child: SizedBox(
          //                   height: 50,
          //                   width: 160,
          //                   child: RaisedButton(
          //                       elevation: 10.0,
          //                       shape: RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.circular(5)),
          //                       highlightElevation: 20.0,
          //                       hoverColor: Colors.white,
          //                       color: Colors.white,
          //                       child: SingleChildScrollView(
          //                         child: Column(
          //                           mainAxisAlignment: MainAxisAlignment.center,
          //                           children: [
          //                             Container(
          //                                 child: SingleChildScrollView(
          //                                     scrollDirection: Axis.vertical,
          //                                     child: Text('Оқылған',
          //                                         style: TextStyle(
          //                                             fontWeight: FontWeight.bold,
          //                                             fontSize: 15)))),
          //                             Container(
          //                                 child: SingleChildScrollView(
          //                                     scrollDirection: Axis.vertical,
          //                                     child: Text('әңгімелер',
          //                                         style: TextStyle(
          //                                             fontWeight: FontWeight.bold,
          //                                             fontSize: 15)))),
          //                           ],
          //                         ),
          //                       ),
          //                       textColor: Colors.black,
          //                       disabledTextColor: Colors.black,
          //                       disabledColor: Colors.grey,
          //                       onPressed: () {}),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //
          //         bookItem(),
          //         bookItem(),
          //
          //       ],
          //     ),
          //   ],
          // ),
          ),
    );
  }

  Widget finishedBookList(BuildContext context) {
    if (_bookList.length > 0) {
      return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _bookList.length,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            itemBuilder: (context, i) {
              return bookItem(context, _bookList[i]);
            }),
      );
    }
  }

  Widget bookItem(BuildContext co, Book book) {
    double width = MediaQuery.of(context).size.width;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      elevation: 6.0,
      child: SizedBox(
        height: 150.0,
        child: InkWell(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10),
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: FadeInImage.assetNetwork(
                            placeholder: 'images/book-cover.png',
                            height: width / 3,
                            width: width / 4.5,
                            image: book.photo))),
              ),
              Flexible(
                  child: Container(
                margin: EdgeInsets.only(bottom: 10, left: 10, top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                        flex: 1,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(book.name,
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(book.author,
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 15)),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text('Бітірген күні: ${book.date}',
                                      maxLines: 1,
                                      style: TextStyle(fontSize: 15)),
                                ),
                              ),
                            ])),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
