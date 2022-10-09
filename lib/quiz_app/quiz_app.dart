import 'package:flutter/material.dart';

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My First App'),
        ),
        body: const Text('This is my default text!'),
      ),
    );
  }
}
