import 'package:time_manager/persistence/ActivityObject.dart';

abstract class IStorage {
  void addActivity(ActivityObject object);

  void updateActivity(ActivityObject object);

  void deleteActivity(ActivityObject object);

  Stream<List<ActivityObject>> getActivities();

  void setDebug();
}
