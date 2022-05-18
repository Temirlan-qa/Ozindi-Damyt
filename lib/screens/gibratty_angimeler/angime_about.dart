import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:ozindi_damyt/screens/gibratty_angimeler/angime.dart';
import 'package:like_button/like_button.dart';
import 'dart:ui';
import 'angime.dart';
// Қолданбай жатқан код

class Angime_about extends StatelessWidget {
  final Angime angime;

  Angime_about({Key key, @required this.angime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double text = MediaQuery.textScaleFactorOf(context);
    print(width);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[

            SizedBox(
              height: 210,
              child: Container(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                  child: Container(
                    decoration:
                    BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(angime.photo), fit: BoxFit.cover)),
              ),
            ),

            Column(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 10, top: 30),
                    child: Transform.rotate(
                      angle: 0 * pi / 180,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.white, size: 45),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    )),
            
              ],
            ),

            Container(
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
              child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 205),
                    child: ListView(children: [
                      Padding(
                        padding:
                        const EdgeInsets.only(left: 20.0, right: 20, bottom: 15),
                        child: Column(
                          children: [
                            Text(
                              angime.title,
                              style: TextStyle(fontSize: width/20,),
                            ),
                            Divider(),
                            Text(
                              angime.desc,
                              style: TextStyle(fontSize: width/25),
                            ),
                          ],
                        ),
                      )
                    ]),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}