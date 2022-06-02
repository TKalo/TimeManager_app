import 'package:flutter/material.dart';

class Category {
  String id;
  String name;
  Color color;

  Category({this.id = "", required this.name, required this.color});

  Map<String, String> toMap() => {'_id' : id.toString(), 'name': name, 'color': color.value.toRadixString(16).toString()};

  Category.fromJson(Map<String, dynamic> map)
      : id = map['_id'] ?? '',
        name = map['name'] ?? '',
        color = Color(int.parse(map['color'], radix: 16));

  Category copy() => Category(name: name, color: color);
}
