import 'package:flutter/material.dart';

class QuizFormScreen extends StatelessWidget {
  const QuizFormScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController subjectController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController pointController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme: (IconThemeData(color: Colors.black)),
        title: Text(
          'Quiz нәтижелерін толтыру',
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
            children: [
              SizedBox(height: 20,),
              Text('Қазақстан тарихы/type of subject'),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Сабақ пәнін таңда',
                ),
              ),
              SizedBox(height: 20,),
              Text('19.01/ date'),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Уақытын таңда',
                ),
              ),
              SizedBox(height: 20,),
              Text('100/80 point'),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Доп. инфа',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
