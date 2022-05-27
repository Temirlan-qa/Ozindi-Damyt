import 'package:flutter/material.dart';

class SportFormScreen extends StatelessWidget {
  const SportFormScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController sportController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController stepController = TextEditingController();
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
              SizedBox(height: 20,),
              Text('Жүгіру/ type of sport '),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Спорт түрін таңда',
                ),
              ),
              SizedBox(height: 20,),
              Text('19.01/ date'),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Күнін таңда',
                ),
              ),
              SizedBox(height: 20,),
              Text('56 мин/ time in minute'),
              SizedBox(height: 5,),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Уақытын жаз',
                ),
              ),
              SizedBox(height: 20,),
              Text('6340 қадам'),
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
