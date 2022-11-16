import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ViewPortDimensions {
  late Size size;
  late double width;
  late double height;
  ViewPortDimensions() {
    var physicalSize = ui.window.physicalSize;
    var devicePixelRatio = ui.window.devicePixelRatio;
    size = physicalSize / devicePixelRatio;
    width = size.width;
    height = size.height;
  }
}
