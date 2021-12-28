import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';



class AddCategoryViewModel {
  static final AddCategoryViewModel _singleton = AddCategoryViewModel._internal();
  factory AddCategoryViewModel() => _singleton;
  AddCategoryViewModel._internal();

  final CategoryObject category = CategoryObject(name: '', color: Colors.grey);

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

                      Navigator.pop(
                        context,
                        category.color.value.toRadixString(16)
                      );
                    },
                  ),
                ]));
  }
  
}
