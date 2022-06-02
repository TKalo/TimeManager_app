

import 'package:time_manager/Database/FileDatabase/ActivityDatabase.dart';
import 'package:time_manager/Database/FileDatabase/CategoryDatabase.dart';
import 'package:time_manager/Database/Interfaces/i_backend_database.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';

import 'file_connection.dart';

class FileDatabase implements IBackendDatabase {
  final bool debug;
  final ActivityDatabase _activityDB;
  final CategoryDatabase _categoryDB;

  FileDatabase({required this.debug})
      : _activityDB = ActivityDatabase(connection: debug ? FileConnection(filename: 'activities_test') : FileConnection(filename: 'activities')),
        _categoryDB = CategoryDatabase(connection: debug ? FileConnection(filename: 'categories_test') : FileConnection(filename: 'categories'));

  @override
  Future<DatabaseResponse<void>> addCategory(Category category) => _categoryDB.addCategory(category);

  @override
  Future<DatabaseResponse<void>> deleteCategory(Category category) => _categoryDB.deletecategory(category);

  @override
  Future<DatabaseResponse<List<Category>>> getCategories() => _categoryDB.getcategories();

  @override
  Future<DatabaseResponse<void>> updateCategory(Category category) => _categoryDB.updatecategory(category);

  @override
  Future<DatabaseResponse<String>> addActivity(Activity activity) => _activityDB.addActivity(activity);

  @override
  Future<DatabaseResponse<void>> deleteActivity(Activity activity) => _activityDB.deleteActivity(activity);

  @override
  Future<DatabaseResponse<List<Activity>>> getActivities() => _activityDB.getActivities();

  @override
  Future<DatabaseResponse<void>> updateActivity(Activity activity) => _activityDB.updateActivity(activity);
}
