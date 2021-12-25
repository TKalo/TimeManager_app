import 'package:time_manager/persistence/Objects/CategoryObject.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Interfaces/IDatabase.dart';

import '../Objects/DatabaseResponseObject.dart';

abstract class IBackendDatabase implements IDatabase {

  @override
  Future<DatabaseResponseObject<List<ActivityObject>>> getActivities();

  @override
  Future<DatabaseResponseObject<List<CategoryObject>>> getCategories();
}
