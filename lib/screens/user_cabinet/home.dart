import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ozindi_damyt/authentication/current_book.dart';
import 'package:ozindi_damyt/authentication/current_user.dart';
import 'package:intl/intl.dart';
import 'package:ozindi_damyt/screens/user_cabinet/current_book_read_pages.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'package:toast/toast.dart';
import '../../main.dart';
import 'book_dayli_pages.dart';

class UserHome2 extends StatefulWidget {
  @override
  UserHome2State createState() => UserHome2State();
}

class UserHome2State extends State<UserHome2> {
  bool showAddPage = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String userEmail = "user@gmail.com";
  Query _currentUserQuery, _currentBookReadPages;
  CurrentUser currentUser =
      CurrentUser(info: "test", dostykName: "test", phoneNumber: "test");
  CurrentBook currentBook = CurrentBook(
      author: "test", name: "test", photo: "url", readPage: "0", fullPage: "0");
  TextEditingController addBookPageText = TextEditingController();
  bool yesCurrentBook = false, readPageReport = false;
  String firebaseEmailConverted, currentUserKey;
  Map<dynamic, dynamic> readDates;
  List<BookDayliPages> _bookDayliPages;

  @override
  void initState() {
    super.initState();

    User currentUser = auth.currentUser;

    if (currentUser != null) {
      setState(() {
        userEmail = currentUser.email;
      });

      firebaseEmailConverted = userEmail.replaceAll('.', "-");
      readDates = new Map();

      _currentUserQuery = _database
          .reference()
          .child("user_list")
          .child(firebaseEmailConverted);

      _currentUserQuery.onChildAdded.listen(onEntryAdded);
    }
  }

  onEntryAdded(Event event) {
    _currentUserQuery.once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        Map<dynamic, dynamic> values = snapshot.value;
        values.forEach((key, values) {
          currentUserKey = key;

          setState(() {
            currentUser = CurrentUser.fromSnapshot(values);

            if (values["currentBook"] != null) {
              currentBook = CurrentBook.fromValues(values["currentBook"]);
              addBookPageText.text = '${currentBook.readPage}';
              yesCurrentBook = true;

              if (values["currentBook"]["readPageReport"] != null) {
                readPageReport = true;

                readDates = values["currentBook"]["readPageReport"];
              }
            }
          });
        });
      }
    });
  }

  void _btnAddPage() {
    print('currentBook.readPage: ${currentBook.readPage}');
    print('addBookPageText.text: ${addBookPageText.text}');

    setState(() {
      showAddPage = !showAddPage;
    });

    if (!showAddPage &&
        int.parse(addBookPageText.text) <= int.parse(currentBook.readPage)) {
      showToast(context,
          text: 'Төмен және тең сан енгізуге болмайды!',
          textColor: Colors.white,
          backColor: secondaryColor);
    } else if (!showAddPage &&
        int.parse(addBookPageText.text) >= int.parse(currentBook.fullPage)) {
      showAlertDialog(context);
    } else if (!showAddPage) {
      setState(() {
        currentBook.readPage = addBookPageText.text;
      });

      if (!showAddPage) {
        addReadPageByDate();
      }
    }
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Жоқ"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Ия"),
      onPressed: () {
        finishBook();
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Кітап соңы"),
      content: Text(
          "Сіз шынымен осы кітапты бітіргіңіз келеді ма?\nКітап күндік оқудан өшіріледі"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void addReadPageByDate() {
    var previousPage;

    final now = new DateTime.now();
    String today = DateFormat('dd-MM').format(now);

    if (readPageReport) {
      readDates.remove(today);
      var lastReadPage = 0;

      readDates.forEach((key, values) {
        lastReadPage = lastReadPage + int.parse(values);
      });
      previousPage = lastReadPage;
    } else {
      previousPage = 0;
    }

    _database
        .reference()
        .child("user_list")
        .child(firebaseEmailConverted)
        .child(currentUserKey)
        .child("currentBook")
        .child("readPage")
        .set(addBookPageText.text)
        .asStream();

    var readPageCount = int.parse(currentBook.readPage) - previousPage;

    readDates[today] = '$readPageCount';

    readPageReport = true;

    _database
        .reference()
        .child("user_list")
        .child(firebaseEmailConverted)
        .child(currentUserKey)
        .child("currentBook")
        .child("readPageReport")
        .set(readDates)
        .asStream();

    _database
        .reference()
        .child("user_list")
        .child(firebaseEmailConverted)
        .child(currentUserKey)
        .child("lastReadDate")
        .set(today)
        .asStream();
  }

  void finishBook() {
    // _database.reference()
    //     .child("user_list").child(firebaseEmailConverted)
    //     .child(currentUserKey).child("readBooks").push().set(currentBook.toFinishBook).asStream();

    // _database.reference()
    //     .child("user_list").child(firebaseEmailConverted)
    //     .child(currentUserKey).child("readBooks").push().set('yahoo').asStream();

    Query _currentUserQ = _database
        .reference()
        .child("user_list")
        .child(firebaseEmailConverted)
        .child("key1")
        .child("bookCount");

    _currentUserQ.once().then((DataSnapshot snapshot) {
      if (snapshot != null) {
        var bookCount = snapshot.value + 1;

        _database
            .reference()
            .child("user_list")
            .child(firebaseEmailConverted)
            .child("key1")
            .child("bookCount")
            .set(bookCount);

        _database
            .reference()
            .child("user_list")
            .child(firebaseEmailConverted)
            .child("key1")
            .child("point")
            .set(bookCount * 10);
      }
    });

    _database
        .reference()
        .child("user_list")
        .child(firebaseEmailConverted)
        .child(currentUserKey)
        .child("readBooks")
        .push()
        .set(currentBook.toFinishBook())
        .then((value) {
      setState(() {
        yesCurrentBook = false;
        currentBook = CurrentBook(
            author: "test",
            name: "test",
            photo: "url",
            readPage: "0",
            fullPage: "0");
      });

      _database
          .reference()
          .child("user_list")
          .child(firebaseEmailConverted)
          .child(currentUserKey)
          .child("currentBook")
          .remove();

      showToast(context,
          text: 'Сіз кітапты сәтті аяқтадыңыз!',
          textColor: Colors.white,
          backColor: Colors.green);
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(width / 2),
          child: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              margin: EdgeInsets.only(top: 30),
              child: FlexibleSpaceBar(
                centerTitle: true,
                title: userInfo(),
              ),
            ),
          ),
        ),
        body: Container(child: bookItem()),
      ),
    );
  }

  void _btnDeleteBook() {
    showDeleteBookDialog(context);
  }

  showDeleteBookDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Жоқ"),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Иә"),
      onPressed: () {
        setState(() {
          yesCurrentBook = false;
          currentBook = CurrentBook(
              author: "test",
              name: "test",
              photo: "url",
              readPage: "0",
              fullPage: "0");
        });

        _database
            .reference()
            .child("user_list")
            .child(firebaseEmailConverted)
            .child(currentUserKey)
            .child("currentBook")
            .remove();

        showToast(context,
            text: 'Сіз кітапты сәтті өшірдіңіз !',
            textColor: Colors.white,
            backColor: Colors.green);

        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Кітап өшіру"),
      content: Text("Кітап өшіруді қалайсыз ба?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget userInfo() {
    return Center(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: <Widget>[
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    currentUser.info,
                    // 'Dostyq User',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      currentUser.phoneNumber,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      userEmail,
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      currentUser.dostykName,
                      // 'Атырау Достық',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
              CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.blue,
                  child: Image.asset('images/user_icon.png')),
            ],
          ),
        ],
      ),
    );
  }

  Widget bookItem() {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double text = MediaQuery.textScaleFactorOf(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
      elevation: 6.0,
      child: SizedBox(
        height: 150.0,
        child: InkWell(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (readPageReport) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CurrentBookReadPages(
                              currentBook: currentBook, readDates: readDates)),
                    ).then((value) => setState(() {
                          _currentUserQuery.onChildAdded.listen(onEntryAdded);
                        }));
                  } else {
                    showToast(context,
                        text:
                            "Кітап әлі оқылмаған соң, қай күндер оқылған көрсетілмейді!",
                        textColor: Colors.white,
                        backColor: secondaryColor);
                  }
                },
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: FadeInImage.assetNetwork(
                            placeholder: 'images/book-cover.png',
                            height: width / 3,
                            width: width / 4.5,
                            image: currentBook.photo))),
              ),
              Flexible(
                  flex: 1,
                  child: Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, top: 20),
                      child: yesCurrentBook
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flexible(
                                    flex: 1,
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(currentBook.name,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18)),
                                          ),
                                          Flexible(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Text(currentBook.author,
                                                  maxLines: 1,
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                            ),
                                          )
                                        ])),
                                Flexible(
                                  flex: 1,
                                  child: Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: SizedBox(
                                                height: width / 14,
                                                child: (showAddPage
                                                    ? addReadPage()
                                                    : normalStateBookPage())),
                                          ),
                                        ],
                                      )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: SizedBox(
                                    height: width / 14,
                                    child: FloatingActionButton(
                                      heroTag: null,
                                      onPressed: _btnAddPage,
                                      backgroundColor: Colors.white,
                                      child: (showAddPage
                                          ? Icon(
                                              Icons.save,
                                              color: Colors.grey,
                                            )
                                          : Icon(
                                              Icons.add_circle_outlined,
                                              color: Colors.grey,
                                            )),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text('Оқылатын кітап таңдалмады'))),
              yesCurrentBook
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 14.0),
                            child: SizedBox(
                              height: width / 15,
                              child: FloatingActionButton(
                                  heroTag: null,
                                  onPressed: _btnDeleteBook,
                                  backgroundColor: Colors.white,
                                  child:
                                      Icon(Icons.close, color: secondaryColor)),
                            ),
                          )
                        ])
                  : Text('')
            ],
          ),
        ),
      ),
    );
  }

  Widget normalStateBookPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('${currentBook.readPage}',
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Text('/${currentBook.fullPage} бет',
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }

  Widget addReadPage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _input(addBookPageText),

        Text('/${currentBook.fullPage} бет',
            maxLines: 1,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        //
        // new FloatingActionButton(
        //   heroTag: null,
        //   onPressed: _btnSave,
        //   child: new Icon(
        //     Icons.save,
        //     color: Colors.grey,
        //   ),
        //   backgroundColor: Colors.white,
        // ),
      ],
    );
  }

  Widget _input(TextEditingController controller) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double text = MediaQuery.textScaleFactorOf(context);

    return Container(
      padding: EdgeInsets.only(left: 1, right: 1),
      width: width / 5.5,
      height: width / 5,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        obscureText: false,
        style: TextStyle(
            fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        // maxLength: 4,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 1)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1)),
        ),
        // maxLength: 4,
      ),
    );
  }

  Widget sportItem() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
      elevation: 6.0,
      child: SizedBox(
        height: 60.0,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.directions_run_rounded,
              ),
              Row(
                children: [
                  Container(
                      child: Container(
                    child: Text('Спорт',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                  )),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                          child: Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Text('152',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [Text('мин ')],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget quizItem() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
      elevation: 6.0,
      child: SizedBox(
        height: 60.0,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                Icons.comment_outlined,
              ),
              Row(
                children: [
                  Container(
                      child: Container(
                    child: Row(
                      children: [
                        Text('Quiz',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      ],
                    ),
                  )),
                ],
              ),
              Row(
                children: [
                  Row(
                    children: [
                      Container(
                          child: Container(
                        margin: EdgeInsets.only(left: 50),
                        child: Text('280',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 17)),
                      )),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [Text('балл ')],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showToast(BuildContext context,
      {String text, Color textColor, Color backColor}) {
    Toast.show(text, context,
        duration: Toast.LENGTH_LONG,
        textColor: textColor,
        backgroundColor: backColor,
        gravity: Toast.BOTTOM);
  }
}
