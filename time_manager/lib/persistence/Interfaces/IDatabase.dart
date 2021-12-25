import 'package:time_manager/persistence/Objects/CategoryObject.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';

abstract class IDatabase {
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject object);

  dynamic getActivities();

  Future<DatabaseResponseObject<int>> addCategory(CategoryObject object);

  Future<DatabaseResponseObject<void>> updateCategory(CategoryObject object);

  Future<DatabaseResponseObject<void>> deleteCategory(CategoryObject object);

  dynamic getCategories();
}
