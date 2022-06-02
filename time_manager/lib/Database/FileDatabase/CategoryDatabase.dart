import 'dart:convert';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';
import 'package:time_manager/Utilities/functions.dart';

import 'file_connection.dart';

class CategoryDatabase {
  final FileConnection connection;

  CategoryDatabase({required this.connection});

  Future<DatabaseResponse<void>> addCategory(Category category) async {
    try {
      //get existing activies
      List<Category> categories = notNullOrFail((await getcategories()).result);

      //Check name not in use
      if (categories.any((existingCategory) => existingCategory.name == category.name)) throw Exception('name is already in use');

      //Check color not in use
      if (categories.any((existingCategory) => existingCategory.color == category.color)) throw Exception('color is already in use');

      //add new category
      categories.add(category);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponse<int>.success();
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }

  Future<DatabaseResponse> updatecategory(Category category) async {
    try {
      //get existing activies
      List<Category> categories = notNullOrFail((await getcategories()).result);

      //remove old version of category and add new version
      categories.removeWhere((existingcategory) => existingcategory.name == category.name);
      categories.add(category);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponse<void>.success();
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }

  Future<DatabaseResponse> deletecategory(Category category) async {
    try {
      //get existing activies
      List<Category> categories = notNullOrFail((await getcategories()).result);

      //add new category
      categories.removeWhere((existingcategory) => existingcategory.name == category.name);

      //persist new category list
      await connection.overwriteDatabase(categoryToJson(categories));

      return DatabaseResponse<void>.success();
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }

  Future<DatabaseResponse<List<Category>>> getcategories() async {
    try {
      String json = await connection.loadDatabase();

      List<Category> categories = jsonTocategories(json);

      return DatabaseResponse.success(result: categories);
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }
}

String categoryToJson(List<Category> categories) => jsonEncode(categories.map((category) => category.toMap()).toList());

List<Category> jsonTocategories(String json) => json == '' ? [] : jsonDecode(json).map<Category>((e) => Category.fromJson(e)).toList();
