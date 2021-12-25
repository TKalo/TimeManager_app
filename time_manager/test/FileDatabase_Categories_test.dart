import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/persistence/FileDatabase/CategoryDatabase.dart';
import 'package:time_manager/persistence/FileDatabase/FileDatabase.dart';
import 'package:time_manager/persistence/Objects/CategoryObject.dart';

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
    CategoryObject activity1 = CategoryObject(id: 1, name: 'name', color: Colors.black);
    CategoryObject activity2 = CategoryObject(id: 2, name: 'name', color: Colors.black);
    List<CategoryObject> categories = [activity1, activity2];

    String json = categoryToJson(categories);
    List<CategoryObject> formattedActivities = jsonTocategories(json);

    for (int x = 0; x < categories.length; x++) {
      expect(formattedActivities[x].id, categories[x].id);
      expect(formattedActivities[x].name, categories[x].name);
      expect(formattedActivities[x].color, categories[x].color);
    }
  });

  group('CRUD operations', () {
    test('Check clean database', () async => expect((await database.getCategories()).result?.length, 0));

    test('test insertion', () {
      StreamSubscription? sub;
      sub = testOrder.listen((order) async {
        if (order == 1) {
          String name = 'name';
          Color color = Colors.black;
          CategoryObject category = CategoryObject(name: name, color: color);
          await database.addCategory(category);

          CategoryObject retrievedCategory = notNullOrFail((await database.getCategories()).result?[0]);
          expect(retrievedCategory.id == -1, false);
          expect(retrievedCategory.name, name);
          expect(retrievedCategory.color, color);
          sub?.cancel();
          testOrder.add(2);
        }
      });
    });

    test('test update name', () {
      StreamSubscription? sub;
      sub = testOrder.listen((order) async {
        if (order == 2) {
          CategoryObject category = notNullOrFail((await database.getCategories()).result?[0]);

          String newName = category.name + 'new';
          category.name = newName;
          await database.updateCategory(category);

          CategoryObject newCategory = notNullOrFail((await database.getCategories()).result?[0]);

          expect(newCategory.id, category.id);
          expect(newCategory.name, newName);
          expect(newCategory.color, category.color);
          sub?.cancel();
          testOrder.add(3);
        }
      });
    });

    test('test update color', () {
      StreamSubscription? sub;
      sub = testOrder.listen((order) async {
        if (order == 3) {
          CategoryObject category  = notNullOrFail((await database.getCategories()).result?[0]);

          Color newColor = Colors.white;
          category.color = newColor;
          await database.updateCategory(category);

          CategoryObject newCategory  = notNullOrFail((await database.getCategories()).result?[0]);

          expect(newCategory.id, category.id);
          expect(newCategory.name, category.name);
          expect(newCategory.color, newColor);
          sub?.cancel();
          testOrder.add(4);
        }
      });
    });
  });
}
