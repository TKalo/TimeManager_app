
import 'package:time_manager/Database/Interfaces/IDatabase.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';

import '../Objects/DatabaseResponseObject.dart';

abstract class IBackendDatabase implements IDatabase {

  @override
  Future<DatabaseResponseObject<List<ActivityObject>>> getActivities();

  @override
  Future<DatabaseResponseObject<List<CategoryObject>>> getCategories();
}
