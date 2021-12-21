import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/DatabaseResponseObject.dart';

abstract class IDatabase {
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject object);

  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject object);

  dynamic getActivities();
}
