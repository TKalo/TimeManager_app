import 'package:flutter/material.dart';

class Category {

  String name;
  Color color;

  Category({required this.name, required this.color});

  Map<String, String> toMap() =>
      {'name': name, 'color': color.value.toRadixString(16)};

  Category.fromJson(Map<String, dynamic> map)
      : name = map['name'] ?? '',
        color = Color(int.parse(map['color'], radix: 16));
  
  Category copy() => Category(name: name, color: color);
}
