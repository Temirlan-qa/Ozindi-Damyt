import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ozindi_damyt/screens/kitapkhana/library.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ozindi_damyt/utils/colors.dart';
import 'package:toast/toast.dart';

import 'package:provider/provider.dart';
import 'authentication_provider.dart';

class AuthorizationPage extends StatefulWidget {
  @override
  _AuthorizationPageState createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _email;
  String _password;
  bool showLogin = true;
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    Firebase.initializeApp();

  }

  void authen(String _email,String _password, BuildContext context) async {
    setState(() {
      showLogin = false;
    });

    try {

      // UserCredential userCredential = context.read<AuthenticationProvider>().signIn(
      //   email: _email,
      //   password: _password,
      // ) as UserCredential;

      // context.read<AuthenticationProvider>().signIn(
      //   email: _email,
      //   password: _password,
      // );

      UserCredential result = await auth.signInWithEmailAndPassword(email: _email, password: _password);
      if(result != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (BuildContext context) {
          return LibraryPage();
        }));
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorToast('Қолданушы табылмады! Логинды басынан енгізіңіз');
        // print('No user found for that email.');
        setState(() {
          showLogin = true;
        });

      } else if (e.code == 'wrong-password') {
        showErrorToast('Құпия сөзі қате енгізілді');
        // print('Wrong password provided for that user.');
        setState(() {
          showLogin = true;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    void _buttonAction(){
      _email = _emailController.text.trim();
      _password = _passwordController.text.trim();

      authen(_email, _password, context);

      // _emailController.clear();
      // _passwordController.clear();

    }

    Widget _input(Icon icon, String hint, TextEditingController controller, bool obscure){
      return Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 3)
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: secondaryColor, width: 1)
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: IconTheme(
                data: IconThemeData(color: Colors.black),
                child: icon,
              ),
            )
          ),
        ),
      );
    }

    Widget _logo(){
      return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Container(
          child: Align(
            child: Image(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/5,
                image: AssetImage('images/od_icon.png'))),
            // Text('Library', style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
        );
    }

    Widget _button(String text, void func()){
      return RaisedButton(
        splashColor: Theme.of(context).primaryColor,
        highlightColor: secondaryColor,
        color: secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 20),
        ),
        onPressed: (){
          func();
        },
      );
    }

    Widget _progress(){
      return RaisedButton(
        onPressed: (){},
        splashColor: Theme.of(context).primaryColor,
        highlightColor: secondaryColor,
        color: secondaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0)),
        child: new CircularProgressIndicator(backgroundColor: secondaryColor),
      );
    }

    Widget _form(String label, void func()){
      double width = MediaQuery.of(context).size.width;
      return Container(
        child: SizedBox(width: width/1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 20, top: 40),
                child:_input(Icon(Icons.email), 'Email', _emailController, false),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: _input(Icon(Icons.lock), 'Password', _passwordController, true),
              ),
              // SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10, top: 20),
                child: Container(
                  height:width/6,
                  width: width/1,
                  child:
                  (showLogin
                      ? _button(label, func)
                      : _progress()
                  )
                  ,
                ),
              ),
            ],
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      resizeToAvoidBottomInset:false,
        body: SingleChildScrollView(
                child: Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _logo(),
                    Column(
                      children: [
                        _form('Логин', _buttonAction),
                      ],
                    )
                  ],
                  /*


                  */
                ),
        )));
  }

  void showErrorToast(String text){

    Toast.show(text,
        context,
        duration: Toast.LENGTH_LONG,
        backgroundColor: secondaryColor,
        gravity:  Toast.BOTTOM);
  }
}
