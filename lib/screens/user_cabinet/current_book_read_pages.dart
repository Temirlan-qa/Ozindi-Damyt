import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';

import 'package:ozindi_damyt/authentication/current_book.dart';

import 'book_dayli_pages.dart';
import 'home.dart';

class CurrentBookReadPages extends StatefulWidget {
  final CurrentBook currentBook;
  Map<dynamic, dynamic> readDates;

  CurrentBookReadPages({Key key, @required this.currentBook, this.readDates}) : super(key: key);

  @override
  CurrentBookReadPagesState createState() => CurrentBookReadPagesState();
}

class CurrentBookReadPagesState extends State<CurrentBookReadPages> {
  List<BookDayliPages> _bookDayliPages = [];

  @override
  void initState() {
    super.initState();

    widget.readDates.forEach((key, values) {
      _bookDayliPages.add(BookDayliPages(date: '$key', page: '$values'));
    });

  }
  Future<bool> _onBackPressed() {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserHome2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                  icon: new Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () => Navigator.of(context).pop(context),
                ),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Кітап оқылған күндер',
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
            bookItem(),
            Expanded(
                child: dayliPagesList(context)
            ),
          ]))),
    );
  }

  Widget bookItem() {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double text = MediaQuery.textScaleFactorOf(context);

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder( side: BorderSide(color: Colors.white), borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 25),
      elevation: 6.0,
      child: SizedBox(
        height: 150.0,
        child: InkWell(
          child: Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(7.0),
                      child: FadeInImage.assetNetwork(
                          placeholder: 'images/book-cover.png',
                          height: width / 3,
                          width: width / 4.5,
                          image: widget.currentBook.photo))),
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
                                      child: Text(widget.currentBook.name,
                                          maxLines: 1,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18)),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: Text(widget.currentBook.author,
                                            maxLines: 1,
                                            style: TextStyle(fontSize: 15)),
                                      ),
                                    )
                                  ])),
                          Flexible(
                            flex: 1,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 1.0),
                                child: Row(
                                  children: <Widget>[
                                    Text('${widget.currentBook.readPage}',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text('/${widget.currentBook.fullPage} бет',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                  ],
                                )),
                          ),
                        ],
                      ))),
            ],
          ),
        ),
      ),
    );
  }

  Widget dayliPagesList(BuildContext context) {
      return Container(
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: _bookDayliPages.length,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            itemBuilder: (context, i) {
              return dayliPagesItem(context, _bookDayliPages[i]);
            }),
      );
  }

  Widget dayliPagesItem(BuildContext context, BookDayliPages bookDayliPages) {
    return Container(
        child: Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Container(
            child: Center(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 13,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                              Container(
                                child: Flexible(
                                  flex: 2,
                                  child: Text(
                                    '${bookDayliPages.date} : ',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                child: Flexible(
                                  flex: 2,
                                  child: Text(
                                    '${bookDayliPages.page} бет',
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],

                    ),
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
