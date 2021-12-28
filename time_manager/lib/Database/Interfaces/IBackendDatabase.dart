
import 'package:time_manager/Database/Interfaces/IDatabase.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';

import '../Objects/DatabaseResponse.dart';

abstract class IBackendDatabase implements IDatabase {

  @override
  Future<DatabaseResponse<List<Activity>>> getActivities();

  @override
  Future<DatabaseResponse<List<Category>>> getCategories();
}
