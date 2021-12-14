import 'package:rxdart/rxdart.dart';
import 'package:time_manager/persistence/IStorage.dart';

import 'ActivityObject.dart';
import 'FileStorage.dart';

class StorageHandler implements IStorage {
  static final StorageHandler _singleton = StorageHandler._internal();
  factory StorageHandler() => _singleton;
  StorageHandler._internal();

  IStorage storage = FileStorage();

  @override
  void addActivity(ActivityObject object) => storage.addActivity(object);

  @override
  void updateActivity(ActivityObject object) => storage.updateActivity(object);

  @override
  void deleteActivity(ActivityObject object) => storage.deleteActivity(object);

  @override
  Stream<List<ActivityObject>> getActivities() => storage.getActivities();

  @override
  void setDebug() => storage.setDebug();
}
