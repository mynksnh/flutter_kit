import 'package:flutter/material.dart';

import './categories_screen.dart';

void main() => runApp(DeliMeals());

class DeliMeals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliMeals',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CategoriesScreen(),
    );
  }
}
