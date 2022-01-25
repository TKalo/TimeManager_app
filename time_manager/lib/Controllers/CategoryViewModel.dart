import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_manager/Database/DatabaseHandler.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';
import 'package:time_manager/Utilities/Objects.dart';


class CategoryViewModel {
  static final CategoryViewModel _singleton = CategoryViewModel._internal();
  factory CategoryViewModel() => _singleton;
  CategoryViewModel._internal();

  Category category = Category(name: '', color: Colors.grey);
  final BehaviorSubject<String?> _globalError = BehaviorSubject();

  void deleteCategory(Category category) => DatabaseHandler().deleteCategory(category);

  Stream<String?> get globalError => _globalError.stream;

  void _resetCategoryObject() => category = Category(name: '', color: Colors.grey);

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
    DatabaseResponse<void> response = await DatabaseHandler().addCategory(category);
    if (response.success) {
      Navigator.pop(context);
      _resetCategoryObject();
    } else {
      _globalError.add(response.error ?? 'unknown error');
    }
  }
}
