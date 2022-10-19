import 'package:flutter/material.dart';
import './text_layout.dart';

class BasicScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Welcome to Flutter'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.edit),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset('assets/images/beach.jpg'),
            TextLayout(),
          ],
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.lightBlue,
            child: Center(
              child: Text("I'm a Drawer!"),
            ),
          ),
        ),
      ),
    );
  }
}
