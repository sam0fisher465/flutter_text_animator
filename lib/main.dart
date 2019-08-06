import 'package:flutter/material.dart';
import 'package:flutter_text_animator/text_animator/TextAnimator.dart';
import 'package:flutter_text_animator/text_animator/controllers/TextTyperController.dart';
import 'package:flutter_text_animator/text_animator/wrappers/ATextWrapper.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      title: "Flutter app",
      theme: this.appTheme(context),
      home: 
      Scaffold(
        body: 
        Container(
          padding: const EdgeInsets.only(top: 20),
          child: 
          TextAnimator(
            loop: true,
            wrapper: 
            TextBaseWrapper(
              alignment: Alignment.center,
              useFittedBox: false,
            ),
            controller: 
            TextTyperController(
              ["Hello world!", "This is a", "Text animator", "Cool, right?!"],
              Text("sample", style: TextStyle(fontSize: 30),),
              duration: Duration(milliseconds: 200), // per letter
              style: TextTyperStyle.consistentWithDelete
            ),
          )
        ),
      )
    );
  }

  ThemeData appTheme(BuildContext context) =>
  ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: Colors.lightBlue[800],
    accentColor: Colors.cyan[600],
    
    // Define the default font family.
    fontFamily: 'Montse',
    cardTheme: 
    CardTheme(
      color: Colors.black54,
      clipBehavior: Clip.hardEdge,
      shape: 
      RoundedRectangleBorder(
        borderRadius: 
        BorderRadius.all(Radius.elliptical(5, 4)),
      ),
    ),
    
    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: 
    TextTheme(
      headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
      title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      caption: TextStyle(color: Colors.yellow[400], fontSize: 20),

    ),
  );
}