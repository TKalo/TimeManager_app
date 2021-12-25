import 'package:time_manager/persistence/FileDatabase/ActivityDatabase.dart';
import 'package:time_manager/persistence/FileDatabase/CategoryDatabase.dart';
import 'package:time_manager/persistence/Objects/CategoryObject.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';
import 'package:time_manager/persistence/Interfaces/IBackendDatabase.dart';

import 'FileConnection.dart';

class FileDatabase implements IBackendDatabase {
  final bool debug;
  final ActivityDatabase _activityDB;
  final CategoryDatabase _categoryDB;

  FileDatabase({required this.debug})
      : _activityDB = ActivityDatabase(connection: debug ? FileConnection(filename: 'activities_test') : FileConnection(filename: 'activities')),
        _categoryDB = CategoryDatabase(connection: debug ? FileConnection(filename: 'categories_test') : FileConnection(filename: 'categories'));

  @override
  Future<DatabaseResponseObject<int>> addCategory(CategoryObject category) => _categoryDB.addCategory(category);

  @override
  Future<DatabaseResponseObject<void>> deleteCategory(CategoryObject category) => _categoryDB.deletecategory(category);

  @override
  Future<DatabaseResponseObject<List<CategoryObject>>> getCategories() => _categoryDB.getcategories();

  @override
  Future<DatabaseResponseObject<void>> updateCategory(CategoryObject category) => _categoryDB.updatecategory(category);

  @override
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject activity) => _activityDB.addActivity(activity);

  @override
  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject activity) => _activityDB.deleteActivity(activity);

  @override
  Future<DatabaseResponseObject<List<ActivityObject>>> getActivities() => _activityDB.getActivities();

  @override
  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject activity) => _activityDB.updateActivity(activity);
}
