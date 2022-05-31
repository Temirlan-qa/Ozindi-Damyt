import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ozindi_damyt/screens/user_cabinet/quiz_profile/question_beta.dart';
import 'package:ozindi_damyt/screens/user_cabinet/quiz_profile/quiz.dart';
import 'package:ozindi_damyt/screens/user_cabinet/sport_profile/sport.dart';
import 'package:ozindi_damyt/screens/user_cabinet/sport_profile/sport_beta.dart';
import 'package:ozindi_damyt/screens/user_cabinet/user-books.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'home.dart';
import 'marathon.dart';

class UserCabinet extends StatefulWidget {
  @override
  _UserCabinetState createState() => _UserCabinetState();
}

class _UserCabinetState extends State<UserCabinet> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    UserHome2(),
    UserBooks(),  
    Marafon(),
    SportScreen(),
    // sport_user(),
    QuizScreen(),
  ];
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 25,
            ),
            label: 'Басты мәзір',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.book_outlined,
            ),
            label: 'Кітап оқу',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.event_available_outlined,
            ),
            label: 'Марафон',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.directions_run_rounded,
            ),
            label: 'Спорт',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.comment_outlined,
            ),
            label: 'Quiz',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.black,
        onTap: _onItemTap,
        selectedFontSize: 13.0,
        unselectedFontSize: 13.0,
      ),
    );
  }
}
