
import 'package:time_manager/Database/Interfaces/i_database.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/category.dart';

import '../Objects/DatabaseResponse.dart';

abstract class IBackendDatabase implements IDatabase {

  @override
  Future<DatabaseResponse<List<Activity>>> getActivities();

  @override
  Future<DatabaseResponse<List<Category>>> getCategories();
}
