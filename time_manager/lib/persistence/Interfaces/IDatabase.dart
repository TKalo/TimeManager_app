import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';

abstract class IDatabase {
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject object);

  dynamic getActivities();
}
