

import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';

abstract class IDatabase {
  Future<DatabaseResponse<String>> addActivity(Activity object);

  Future<DatabaseResponse<void>> updateActivity(Activity object);

  Future<DatabaseResponse<void>> deleteActivity(Activity object);

  dynamic getActivities();

  Future<DatabaseResponse<void>> addCategory(Category object);

  Future<DatabaseResponse<void>> updateCategory(Category object);

  Future<DatabaseResponse<void>> deleteCategory(Category object);

  dynamic getCategories();
}
