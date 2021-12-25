import 'package:flutter/material.dart';

class CategoryObject {

  String name;
  Color color;

  CategoryObject({required this.name, required this.color});

  Map<String, String> toMap() =>
      {'name': name, 'color': color.value.toRadixString(16)};

  CategoryObject.fromJson(Map<String, dynamic> map)
      : name = map['name'] ?? '',
        color = Color(int.parse(map['color'], radix: 16));
  
  CategoryObject copy() => CategoryObject(name: name, color: color);
}
