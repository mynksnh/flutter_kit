import './dismissible.dart';
import './list_screen.dart';
import 'package:flutter/material.dart';
import './shape_animation.dart';
import 'animatedlist.dart';
import 'fade_transition.dart';
import 'my_animation.dart';

class AnimApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DismissibleScreen(),
    );
  }
}
