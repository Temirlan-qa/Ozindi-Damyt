import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ozindi_damyt/authentication/current_book.dart';
import 'package:ozindi_damyt/screens/kitapkhana/book.dart';
import 'package:toast/toast.dart';
import 'dart:ui';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'angime.dart';

// Қолданылып жатқан код

class Angime_about extends StatelessWidget {
  final Angime angime;
  Angime_about({Key key, @required this.angime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body:Stack(
          children: <Widget>[
            Column(
              children: [
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
                            image: NetworkImage(angime.photo),
                            fit: BoxFit.cover)
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              spreadRadius: 8,
                              blurRadius: 6,
                              offset: Offset(0,4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(angime.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Text(
                              '${angime.desc.replaceAll("*(", "\n")}',
                              style: TextStyle(
                                fontSize: width/19,
                                color: Colors.black
                              ),
                            ),
                          ],
                        ),
                        ),
                    ]
                  ),
                ),
              ],
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