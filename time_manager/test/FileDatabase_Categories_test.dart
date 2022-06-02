import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_manager/Database/FileDatabase/CategoryDatabase.dart';
import 'package:time_manager/Database/FileDatabase/FileDatabase.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';
import 'package:time_manager/Utilities/functions.dart';

main() {
  final FileDatabase database = FileDatabase(debug: true);
  final BehaviorSubject<int> testOrder = BehaviorSubject.seeded(1);

  tearDownAll(() async {
    List<Category> categories = notNullOrFail((await database.getCategories()).result);

    expect(categories.isEmpty, false);

    await Future.forEach(categories, (Category category) async => await database.deleteCategory(category));

    expect((await database.getCategories()).result?.length, 0);

    testOrder.close();
  });

  test('formatting', () {
    Category activity1 = Category(name: 'name1', color: Colors.black);
    Category activity2 = Category(name: 'name2', color: Colors.black);
    List<Category> categories = [activity1, activity2];

    String json = categoryToJson(categories);
    List<Category> formattedActivities = jsonTocategories(json);

    for (int x = 0; x < categories.length; x++) {
      expect(formattedActivities[x].name, categories[x].name);
      expect(formattedActivities[x].color, categories[x].color);
    }
  });

  group('CRUD operations', () {
    test('Check clean database', () async => expect((await database.getCategories()).result?.length, 0));

    test('test insertion', () async {
      String name = 'name';
      Color color = Colors.black;
      Category category = Category(name: name, color: color);
      await database.addCategory(category);

      Category retrievedCategory = notNullOrFail((await database.getCategories()).result?[0]);
      expect(retrievedCategory.name, name);
      expect(retrievedCategory.color, color);
    });

    test('test existing name insertion', () async {
      String name = 'name';
      Color color = Colors.black;
      Category category = Category(name: name, color: color);
      DatabaseResponse<void> response = await database.addCategory(category);

      expect(response.success, false);
    });

    test('test update color', () async {
      Category category = notNullOrFail((await database.getCategories()).result?[0]);

      Color newColor = Colors.white;
      category.color = newColor;
      await database.updateCategory(category);

      Category newCategory = notNullOrFail((await database.getCategories()).result?[0]);

      expect(newCategory.name, category.name);
      expect(newCategory.color, newColor);
    });
  });
}
