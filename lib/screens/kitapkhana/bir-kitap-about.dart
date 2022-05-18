import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ozindi_damyt/authentication/current_book.dart';
import 'package:ozindi_damyt/screens/kitapkhana/book.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'package:toast/toast.dart';
import 'dart:ui';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class Kitap_about extends StatelessWidget {
  final Book book;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  Query _currentUserQuery;
  String userEmail;
  bool yesCurrentBook = false;
  String currentUserKey;
  String firebaseEmailConverted;

  Kitap_about({Key key, @required this.book}) : super(key: key);

  void getUserInfo(){
    User currentUser = auth.currentUser;

    if(currentUser != null) {
      userEmail = currentUser.email;

      firebaseEmailConverted = userEmail.replaceAll('.' , "-");

      _currentUserQuery = _database
          .reference()
          .child("user_list").child(firebaseEmailConverted);

      _currentUserQuery.once().then((DataSnapshot snapshot){
        if(snapshot != null) {
          Map<dynamic, dynamic> values = snapshot.value;
          values.forEach((key, values) {
            currentUserKey = key;

            if(values["currentBook"] != null){
              yesCurrentBook = true;
            }else{
              yesCurrentBook = false;
            }
          });
        }
      });
    }
  }

  void addBookToReading(BuildContext context, Book book){
    print('addBookToReading');

    CurrentBook currentBook = CurrentBook(author: book.author, name: book.name, photo: book.photo, readPage: "0", fullPage: '${book.page_number}');
    _database.reference()
        .child("user_list").child(firebaseEmailConverted)
        .child(currentUserKey).child("currentBook").set(currentBook.toJson())
          .then((value) {
            showToast(context, text: 'Күндік оқуға сәтті енгізілді', textColor: Colors.white, backColor: Colors.green);
           })
          .catchError((error) {

          });
  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    getUserInfo();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:Stack(
          children: <Widget>[
            SizedBox(
              height: width/1.8,
              child: Container(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(book.photo),
                        fit: BoxFit.cover)
                ),
              ),
            ),
            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left:10, top: 30),
                    child: Transform.rotate(
                      angle: 0 * pi/180,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.white,
                            size: 45),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 20,top: 65),
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8), //color of shadow
                              spreadRadius: 2, //spread radius
                              blurRadius: 12, // blur radius
                            )]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              book.photo,

                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                    Expanded(
                      flex: 2,
                      child:Container(
                          margin: EdgeInsets.only(left: 20, top: 150, right: 20),
                          // width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(book.name,
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold,fontSize: 18)
                              ),
                              Container(
                                  margin: EdgeInsets.only(top: 3),
                                  child: Text(book.author,
                                    style:
                                    TextStyle(
                                        fontSize: 14),)),

                              Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(top: 5,right: 5),
                                    child: Row(
                                      children: [
                                        Icon(Icons.star, color: secondaryColor,size: 16,),
                                        Icon(Icons.star, color: secondaryColor,size: 16,),
                                        Icon(Icons.star, color: secondaryColor,size: 16,),
                                        Icon(Icons.star, color: secondaryColor,size: 16,),
                                        Icon(Icons.star_half, color: secondaryColor,size: 16,),
                                        Container(
                                            margin: EdgeInsets.only(left: 8),
                                            child: Text('4.8',style: TextStyle(fontSize: 14),)),
                                      ],
                                    ),
                                  ),

                                ],
                              ),



                            ],
                          )
                      ),
                    )
                  ],
                ),
                Flexible(
                    child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20,top: 10),
                            child: Text(book.desc,
                              style: TextStyle(fontSize: width/19),),
                          )
                        ]
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8.0),
                  child: SizedBox(
                    height: 40,
                    width:  width,
                    child: RaisedButton(
                        color: Colors.green,
                        hoverColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: const Text('Күндік оқуға енгізу',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),

                        onPressed: () async {

                          if(yesCurrentBook){
                            showToast(context, text: 'Сізде бітпеген кітап бар, бірінші соны бітіру керек!', textColor: Colors.white, backColor: Colors.blueGrey);
                          }else{
                            addBookToReading(context, book);
                          }

                        }
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, bottom: 8.0),
                  child: SizedBox(
                    height: 40,
                    width:  width,
                    child: RaisedButton(
                        color: secondaryColor,
                        hoverColor: secondaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: const Text('Жүктеу',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),

                        onPressed: () async {
                          String url = book.url;
                          if (await canLaunch(url)) {
                            print(url);
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          };
                        }
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  void showToast(BuildContext context, {String text, Color textColor, Color backColor}){
    Toast.show(text,
        context,
        duration: Toast.LENGTH_LONG,
        textColor: textColor ,
        backgroundColor: backColor ,
        gravity:  Toast.CENTER);
  }
}