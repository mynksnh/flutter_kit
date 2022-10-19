import 'package:flutter/material.dart';

import './academindFlutterApps/quiz_app/quiz_app.dart';
import './academindFlutterApps/personal-expenses_app/personal_expenses_app.dart';
import './academindFlutterApps/deli_meals/deli_meals.dart';
import './academindFlutterApps/shop_app/shop_app.dart';
import './academindFlutterApps/great_places_app/great_places_app.dart';
import './flutterCookbook/Ch03WidgetsIntro/basic_screen.dart';
import '../flutterCookbook/Ch03WidgetsIntro/immutable_widget.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(ImmutableWidget());
}
