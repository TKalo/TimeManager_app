

import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Database/Objects/DatabaseResponseObject.dart';

abstract class IDatabase {
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject object);

  dynamic getActivities();

  Future<DatabaseResponseObject<void>> addCategory(CategoryObject object);

  Future<DatabaseResponseObject<void>> updateCategory(CategoryObject object);

  Future<DatabaseResponseObject<void>> deleteCategory(CategoryObject object);

  dynamic getCategories();
}
