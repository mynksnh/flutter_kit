import 'package:diary/widgets/drop_down_select.dart';
import 'package:flutter/material.dart';

import 'viewport_dimensions.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String? _dropdownText;

  @override
  Widget build(BuildContext context) {
    var viewportDim = ViewPortDimensions();
    var toolbarHeight = viewportDim.height * .1;
    var titleTextFontSize = toolbarHeight * .3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        toolbarHeight: toolbarHeight,
        elevation: 4,
        title: Row(children: [
          Text(
            "Diary",
            style: TextStyle(
                fontSize: titleTextFontSize, color: Colors.greenAccent),
          ),
          Text(
            "Book",
            style: TextStyle(
                fontSize: titleTextFontSize, color: Colors.blueAccent),
          )
        ]),
        actions: [
          Row(
            children: [
              DropDownSelect(
                  selectableItems: <String>['Latest', 'Earlist']
                      .map((e) => SelectableItem<String>(
                          item: Text(e,
                              style: const TextStyle(color: Colors.black)),
                          value: e))
                      .toList(),
                  defaultItem: _dropdownText == null
                      ? const Text('Select')
                      : Text(_dropdownText!),
                  onSelect: (v) {
                    setState(() {
                      _dropdownText = v;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }
}
