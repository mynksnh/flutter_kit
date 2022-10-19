import 'package:flutter/material.dart';
import 'controllers/plan_controller.dart';

class PlanProvider extends InheritedWidget {
  final _controller = PlanController();

  PlanProvider({key, Widget? child}) : super(key: key, child: child as Widget);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;

  static PlanController of(BuildContext context) {
    PlanProvider provider = context
        .dependOnInheritedWidgetOfExactType<PlanProvider>() as PlanProvider;
    return provider._controller;
  }
}
