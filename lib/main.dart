import 'package:flutter/material.dart';
import 'package:tictactoe/home_page.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(

      theme: new ThemeData(
          primaryColor: Colors.black
      ),
      home: new HomePage(),
    );
  }
}



