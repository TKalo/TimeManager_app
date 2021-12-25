import 'dart:convert';

import 'package:time_manager/persistence/Objects/CategoryObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';

import '../../helpers.dart';
import 'FileConnection.dart';

class CategoryDatabase {
  final FileConnection connection;

  String categoryToJson(List<CategoryObject> categories) {
    return jsonEncode(categories.map((category) => category.toMap()).toList());
  }

  List<CategoryObject> jsonTocategories(String json) {
    return json == '' ? [] : jsonDecode(json).map<CategoryObject>((e) => CategoryObject.fromJson(e)).toList();
  }

  CategoryDatabase({required this.connection});

  Future<DatabaseResponseObject<int>> addCategory(CategoryObject category) async {
    try {
      //get existing activies
      List<CategoryObject> categories = notNullOrFail((await getcategories()).result);

      //set unused id
      category.id = getUnusedId(categories);

      //add new category
      categories.add(category);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponseObject<int>.success(result: category.id);
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  Future<DatabaseResponseObject> updatecategory(CategoryObject category) async {
    try {
      //get existing activies
      List<CategoryObject> categories = notNullOrFail((await getcategories()).result);

      //remove old version of category and add new version
      categories.removeWhere((existingcategory) => existingcategory.id == category.id);
      categories.add(category);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  Future<DatabaseResponseObject> deletecategory(CategoryObject category) async {
    try {
      //get existing activies
      List<CategoryObject> categories = notNullOrFail((await getcategories()).result);

      //add new category
      categories.removeWhere((existingcategory) => existingcategory.id == category.id);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }


  Future<DatabaseResponseObject<List<CategoryObject>>> getcategories() async {
    try {
      String json = await connection.loadDatabase();

      List<CategoryObject> categories = jsonTocategories(json);

      return DatabaseResponseObject.success(result: categories);
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  int getUnusedId(List<CategoryObject> categories) {
    int id = 0;

    for (id; id < 10000; id++) if (!categories.any((category) => category.id == id)) break;

    return id;
  }
}
