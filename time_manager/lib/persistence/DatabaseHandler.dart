import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_manager/persistence/Objects/CategoryObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';
import 'package:time_manager/persistence/FileDatabase/FileDatabase.dart';
import 'package:time_manager/persistence/Interfaces/IBackendDatabase.dart';
import 'package:time_manager/persistence/Interfaces/IFrontendDatabase.dart';

import '../helpers.dart';
import 'Objects/ActivityObject.dart';

class DatabaseHandler implements IFrontendDatabase {
  static const DatabaseHandler? _singleton = null;
  factory DatabaseHandler({bool debug = false}) => _singleton ?? DatabaseHandler._internal(debug: debug);
  DatabaseHandler._internal({this.debug = false}) : storage = FileDatabase(debug: debug) {
    updateActivityStream();
    updateCategoryStream();
  }

  final bool debug;
  final IBackendDatabase storage;

  final _activityLock = Lock();
  final _categoryLock = Lock();
  final BehaviorSubject<List<ActivityObject>> _activities = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<CategoryObject>> _categories = BehaviorSubject.seeded([]);

  @override
  Stream<List<ActivityObject>> getActivities() => _activities.stream;

  @override
  Stream<List<CategoryObject>> getCategories() => _categories.stream;

  Future<void> updateActivityStream() {
    return _activityLock.synchronized<void>(() async {
      DatabaseResponseObject<List<ActivityObject>> response = await storage.getActivities();
      if (response.success) _activities.add(notNullOrFail<List<ActivityObject>>(response.result));
      return;
    });
  }

  Future<void> updateCategoryStream() {
    return _activityLock.synchronized<void>(() async {
      DatabaseResponseObject<List<ActivityObject>> response = await storage.getActivities();
      if (response.success) _activities.add(notNullOrFail<List<ActivityObject>>(response.result));
      return;
    });
  }

  @override
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject activity) {
    return _activityLock.synchronized<DatabaseResponseObject<int>>(() {
      updateActivityStream();
      return storage.addActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject activity) {
    return _activityLock.synchronized<DatabaseResponseObject<void>>(() {
      updateActivityStream();
      return storage.updateActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject activity) {
    return _activityLock.synchronized<DatabaseResponseObject<void>>(() {
      updateActivityStream();
      return storage.deleteActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<int>> addCategory(CategoryObject category) {
    return _categoryLock.synchronized<DatabaseResponseObject<int>>(() {
      updateCategoryStream();
      return storage.addCategory(category);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> deleteCategory(CategoryObject category) {
    return _categoryLock.synchronized<DatabaseResponseObject<void>>(() {
      updateCategoryStream();
      return storage.deleteCategory(category);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> updateCategory(CategoryObject category) {
    return _categoryLock.synchronized<DatabaseResponseObject<void>>(() {
      updateCategoryStream();
      return storage.updateCategory(category);
    });
  }
}
