import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SportFormScreen extends StatefulWidget {
  const SportFormScreen({Key key}) : super(key: key);

  @override
  State<SportFormScreen> createState() => _SportFormScreenState();
}

class _SportFormScreenState extends State<SportFormScreen> {
  User user;
  @override
  void initState() {
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred){
    setState(() {
      user = userCred;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController sportController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController stepController = TextEditingController();
    final DatabaseReference ref = FirebaseDatabase.instance.reference();
    
    return Scaffold(
      appBar: AppBar(
        iconTheme: (IconThemeData(color: Colors.black)),
        title: Text(
          'Спорт нәтижелерін толтыру',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[], //<Widget>[]
        backgroundColor: Colors.white,
        elevation: 50.0,
        //IconButton
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('Спорт түрін жаз'),
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: sportController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ), 
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  // border: OutlineInputBorder(),
                  // labelText: 'Спорт түрін таңда',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('Күнін жаз'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ), 
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  // border: OutlineInputBorder(),
                  // labelText: 'Күнін таңда',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Text('Қанша уақыт айналыстың'),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: timeController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ), 
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.redAccent,
                    ),
                  ),
                  // border: OutlineInputBorder(),
                  // labelText: 'Уақытын жаз',
                ),
              ),
              // SizedBox(
              //   height: 20,
              // ),
              // Align(
              //   alignment: Alignment.bottomLeft,
              //   child: Text('Қосымша ақпарат'),
              // ),
              // SizedBox(
              //   height: 10,
              // ),
              // TextField(
              //   controller: stepController,
              //   decoration: InputDecoration(
              //     // border: OutlineInputBorder(),
              //     enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.redAccent,
              //       ),
              //     ), 
              //     focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(
              //         color: Colors.redAccent,
              //       ),
              //     ),
              //     // labelText: 'Доп. инфа',
              //   ),
              // ),
              SizedBox(
                height: 50,
              ),
              OutlineButton(
                onPressed: () async{
                  print("${user.email}");
                  await ref.child('user_list').child("${user.email.replaceAll(".", "-")}").child('key1').child('sport_results').push().update({
                    "type": sportController.text,
                    "date": dateController.text,
                    "time": timeController.text,
                    // "step": stepController.text,
                  });
                  Navigator.of(context).pop(null);
                },
                color: Colors.redAccent,
                child: Text('Сақтау'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
