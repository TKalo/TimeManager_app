import 'package:flutter/material.dart';

class CategoryObject {

  int id;
  String name;
  Color color;

  CategoryObject({this.id = -1, required this.name, required this.color});

  Map<String, String> toMap() =>
      {'id': id.toString(), 'name': name, 'color': color.value.toRadixString(16)};

  CategoryObject.fromJson(Map<String, dynamic> map)
      : id = int.parse(map['id'] ?? '-1'),
        name = map['name'] ?? '',
        color = Color(map['color']);
  
  CategoryObject copy() => CategoryObject(id: id, name: name, color: color);
}
