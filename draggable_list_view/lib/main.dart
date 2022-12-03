import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: DraggableList(),
    );
  }
}

class DraggableList extends StatefulWidget {
  const DraggableList({super.key});

  @override
  State<DraggableList> createState() => _DraggableListState();
}

class _DraggableListState extends State<DraggableList> {
  final int listLength = 24;
  late List<bool> _listBool;
  @override
  void initState() {
    super.initState();
    initializeList();
  }

  void initializeList() {
    _listBool = List<bool>.generate(listLength, (x) => x == 0 ? true : false);
  }

  @override
  void dispose() {
    _listBool.clear();
    super.dispose();
  }

  _get(bool datum, int index) {
    if (datum) {
      return Draggable<bool>(
        // Data is the value this Draggable stores.
        data: datum,
        feedback: Container(
          color: Colors.deepOrange,
          child: const Icon(Icons.directions_run),
        ),
        childWhenDragging: Container(
          color: Colors.pinkAccent,
          child: const Center(
            child: Text('Child When Dragging'),
          ),
        ),
        child: Container(
          color: Colors.lightGreenAccent,
          child: const Center(
            child: Text('Draggable'),
          ),
        ),
        onDragCompleted: () {
          _listBool[index] = false;
        },
      );
    } else {
      return DragTarget<bool>(
        builder: (
          BuildContext context,
          List<dynamic> accepted,
          List<dynamic> rejected,
        ) {
          return Container(
            height: 100.0,
            width: 100.0,
            color: Colors.cyan,
            child: Center(
              child: Text('$index'),
            ),
          );
        },
        onAccept: (bool datum) {
          setState(() {
            _listBool[index] = datum;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _listBool.length,
        itemBuilder: (_, int index) {
          return _get(_listBool[index], index);
        });
  }
}
