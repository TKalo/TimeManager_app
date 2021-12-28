import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_manager/Database/DatabaseHandler.dart';
import 'package:time_manager/Database/Interfaces/IFrontendDatabase.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Database/Objects/DatabaseResponseObject.dart';
import 'package:time_manager/Utilities/routes.dart';

class CategoryViewModel {
  static final CategoryViewModel _singleton = CategoryViewModel._internal();
  factory CategoryViewModel() => _singleton;
  CategoryViewModel._internal();

  final CategoryObject category = CategoryObject(name: '', color: Colors.grey);
  IFrontendDatabase storage = DatabaseHandler();
  final BehaviorSubject<String?> globalError = BehaviorSubject();

  Future<String?> pickColor(BuildContext context) async {
    return showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
                content: SingleChildScrollView(
                  child: BlockPicker(pickerColor: category.color, onColorChanged: (color) => category.color = color),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    child: const Text('Got it'),
                    onPressed: () {
                      Navigator.pop(context, category.color.value.toRadixString(16));
                    },
                  ),
                ]));
  }

  void submitActivity(BuildContext context) async {
    DatabaseResponseObject<void> response = await storage.addCategory(category);
    if (response.success)
      Navigator.pushNamed(context, routes.categoryList.name);
    else
      globalError.add(response.error ?? 'unknown error');
  }
}
