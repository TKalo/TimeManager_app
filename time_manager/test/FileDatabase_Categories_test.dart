import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_manager/Database/FileDatabase/CategoryDatabase.dart';
import 'package:time_manager/Database/FileDatabase/FileDatabase.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Database/Objects/DatabaseResponseObject.dart';
import 'package:time_manager/Utilities/helpers.dart';

main() {
  final FileDatabase database = FileDatabase(debug: true);
  final BehaviorSubject<int> testOrder = BehaviorSubject.seeded(1);

  setUp(() => sleep(const Duration(seconds: 1)));

  tearDownAll(() async {
    List<CategoryObject> categories = notNullOrFail((await database.getCategories()).result);

    expect(categories.isEmpty, false);

    await Future.forEach(categories, (CategoryObject category) async => await database.deleteCategory(category));

    expect((await database.getCategories()).result?.length, 0);

    testOrder.close();
  });

  test('formatting', () {
    CategoryObject activity1 = CategoryObject(name: 'name1', color: Colors.black);
    CategoryObject activity2 = CategoryObject(name: 'name2', color: Colors.black);
    List<CategoryObject> categories = [activity1, activity2];

    String json = categoryToJson(categories);
    List<CategoryObject> formattedActivities = jsonTocategories(json);

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
      CategoryObject category = CategoryObject(name: name, color: color);
      await database.addCategory(category);

      CategoryObject retrievedCategory = notNullOrFail((await database.getCategories()).result?[0]);
      expect(retrievedCategory.name, name);
      expect(retrievedCategory.color, color);
    });

    test('test existing name insertion', () async {
      String name = 'name';
      Color color = Colors.black;
      CategoryObject category = CategoryObject(name: name, color: color);
      DatabaseResponseObject<void> response = await database.addCategory(category);

      expect(response.success, false);
    });

    test('test update color', () async {
      CategoryObject category = notNullOrFail((await database.getCategories()).result?[0]);

      Color newColor = Colors.white;
      category.color = newColor;
      await database.updateCategory(category);

      CategoryObject newCategory = notNullOrFail((await database.getCategories()).result?[0]);

      expect(newCategory.name, category.name);
      expect(newCategory.color, newColor);
    });
  });
}
