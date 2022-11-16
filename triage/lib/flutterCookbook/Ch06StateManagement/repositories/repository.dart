import 'package:flutter/foundation.dart';

abstract class Repository {
  Model create();

  List<Model> getAll();
  Model get(int id);
  void update(Model item);

  void delete(Model item);
  void clear();
}

class Model {
  final int id;
  Map data;

  Model({
    required this.id,
    this.data = const {},
  });
}
