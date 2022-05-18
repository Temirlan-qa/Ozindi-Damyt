import 'package:ozindi_damyt/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';

class ProfOrient extends StatefulWidget {

  @override
  _ProfOrientState createState() => _ProfOrientState();
}

class _ProfOrientState extends State<ProfOrient> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    double text = MediaQuery.textScaleFactorOf(context);
    print(width);
    return Scaffold(
        appBar: AppBar(
          
          title: Text(
            "Профориентация",
            style: TextStyle(color: Colors.black),
          ),
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: <Widget>[

            /*
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              tooltip: 'search',
              onPressed: () {},
            ), //IconButton
            //IconButton

             */
          ], //<Widget>[]
          backgroundColor: primaryColor,
          elevation: 50.0,
        ),
        drawer: DrawerMenu(),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Container(
                width: width ,
                height: height / 7,
                child: RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    highlightElevation: 20.0,
                    hoverColor: Colors.white,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Profonline.kz',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 15)),
                        ),
                        //image.jpg
                        Image.asset('images/image.jpg'),
                        // Image.network(
                        //   'https://image.jimcdn.com/app/cms/image/transf/dimension=321x1024:format=jpg/path/sd99b7a7213d94bcf/image/iffa1d2769d6c0cb9/version/1583683614/image.jpg',
                        // ),
                      ],
                    ),
                    textColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    disabledTextColor: Colors.black,
                    disabledColor: Colors.grey,
                    onPressed: () async {
                      const url = 'http://profonline.kz/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      ;
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Container(
                width: width ,
                height: height / 7,
                child: RaisedButton(
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    highlightElevation: 20.0,
                    hoverColor: Colors.white,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text('Nova Education',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: width / 16)),
                        ),
                        Image.asset('images/image 55.png'),
                      ],
                    ),
                    textColor: Colors.black,
                    padding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
                    disabledTextColor: Colors.black,
                    disabledColor: Colors.grey,
                    onPressed: () async {
                      const url = 'https://novaedu.kz/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      ;
                    }),
              ),
            ),
          ],
        ));
  }
}
