import 'package:flutter/material.dart';

import './academindFlutterApps/quiz_app/quiz_app.dart';
import './academindFlutterApps/personal-expenses_app/personal_expenses_app.dart';
import './academindFlutterApps/deli_meals/deli_meals.dart';
import './academindFlutterApps/shop_app/shop_app.dart';
import './academindFlutterApps/great_places_app/great_places_app.dart';

import './flutterCookbook/Ch03WidgetsIntro/basic_screen.dart';
import './flutterCookbook/Ch03WidgetsIntro/immutable_widget.dart';
import './flutterCookbook/Ch04WidgetsTree/deep_tree.dart';
import './flutterCookbook/Ch04WidgetsTree/e_commerce_screen_before.dart';
import './flutterCookbook/Ch04WidgetsTree/e_commerce_screen_after.dart';
import './flutterCookbook/Ch04WidgetsTree/flex_screen.dart';
import './flutterCookbook/Ch04WidgetsTree/profile_screen.dart';
import './flutterCookbook/Ch05NavLoginAlerts/stop_watch_app.dart';
import './flutterCookbook/Ch06StateManagement/master_plan_app.dart';
import './flutterCookbook/Ch07Async/location_app.dart';
import './flutterCookbook/Ch08PersistenceAndHttp/pizza_app.dart';
import './flutterCookbook/Ch09aStreams/StreamAppA.dart';
import './flutterCookbook/Ch09bStreams/stream_app_b.dart';

void main() {
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(StreamB());
}
