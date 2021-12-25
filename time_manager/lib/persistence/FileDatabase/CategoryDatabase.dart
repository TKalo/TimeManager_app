import 'dart:convert';

import 'package:time_manager/persistence/Objects/CategoryObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';

import '../../helpers.dart';
import 'FileConnection.dart';

class CategoryDatabase {
  final FileConnection connection;

  CategoryDatabase({required this.connection});

  Future<DatabaseResponseObject<void>> addCategory(CategoryObject category) async {
    try {
      //get existing activies
      List<CategoryObject> categories = notNullOrFail((await getcategories()).result);

      //Check name not in use
      if (categories.any((existingCategory) => existingCategory.name == category.name)) throw Exception('name is already in use');

      //add new category
      categories.add(category);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponseObject<int>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  Future<DatabaseResponseObject> updatecategory(CategoryObject category) async {
    try {
      //get existing activies
      List<CategoryObject> categories = notNullOrFail((await getcategories()).result);

      //remove old version of category and add new version
      categories.removeWhere((existingcategory) => existingcategory.name == category.name);
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
      categories.removeWhere((existingcategory) => existingcategory.name == category.name);

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
}

String categoryToJson(List<CategoryObject> categories) => jsonEncode(categories.map((category) => category.toMap()).toList());

List<CategoryObject> jsonTocategories(String json) => json == '' ? [] : jsonDecode(json).map<CategoryObject>((e) => CategoryObject.fromJson(e)).toList();
