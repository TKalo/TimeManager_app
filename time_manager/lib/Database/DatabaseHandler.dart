import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_manager/Database/FileDatabase/FileDatabase.dart';
import 'package:time_manager/Database/Interfaces/IBackendDatabase.dart';
import 'package:time_manager/Database/Interfaces/IFrontendDatabase.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';
import 'package:time_manager/Utilities/Functions.dart';

class DatabaseHandler implements IFrontendDatabase {
  static DatabaseHandler? _singleton;
  factory DatabaseHandler({bool debug = false}) => _singleton ?? (_singleton = DatabaseHandler._internal(debug: debug));
  DatabaseHandler._internal({bool debug = false}) : _storage = FileDatabase(debug: debug) {
    _updateStream<Activity>(() => _storage.getActivities(), _activities);
    _updateStream<Category>(() => _storage.getCategories(), _categories);
  }

  final IBackendDatabase _storage;

  final _activityLock = Lock();
  final _categoryLock = Lock();
  final BehaviorSubject<List<Activity>> _activities = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<Category>> _categories = BehaviorSubject.seeded([]);

  // Optimized for minimal code repition

  @override
  Stream<List<Activity>> getActivities() => _activities.stream;

  @override
  Stream<List<Category>> getCategories() => _categories.stream;

  @override
  Future<DatabaseResponse<int>> addActivity(Activity activity) {
    return _activityDatabaseFunction<int>(execution: () => _storage.addActivity(activity));
  }

  @override
  Future<DatabaseResponse<void>> updateActivity(Activity activity) {
    return _activityDatabaseFunction<void>(execution: () => _storage.updateActivity(activity));
  }

  @override
  Future<DatabaseResponse<void>> deleteActivity(Activity activity) {
    return _activityDatabaseFunction<void>(execution: () => _storage.deleteActivity(activity));
  }

  @override
  Future<DatabaseResponse<void>> addCategory(Category category) {
    return _categoryDatabaseFunction(execution: () => _storage.addCategory(category));
  }

  @override
  Future<DatabaseResponse<void>> deleteCategory(Category category) {
    return _categoryDatabaseFunction(execution: () => _storage.deleteCategory(category));
  }

  @override
  Future<DatabaseResponse<void>> updateCategory(Category category) {
    return _categoryDatabaseFunction(execution: () => _storage.updateCategory(category));
  }

  Future<DatabaseResponse<void>> _categoryDatabaseFunction({required Future<DatabaseResponse<void>> Function() execution}) =>
      _databaseFunction(execution: execution, data: () => _storage.getCategories(), stream: _categories, lock: _categoryLock);


  Future<DatabaseResponse<R>> _activityDatabaseFunction<R>({required Future<DatabaseResponse<R>> Function() execution}) =>
      _databaseFunction(execution: execution, data: () => _storage.getActivities(), stream: _activities, lock: _activityLock);

  Future<DatabaseResponse<R>> _databaseFunction<O, R>(
          {required Future<DatabaseResponse<R>> Function() execution, required Future<DatabaseResponse<List<O>>> Function() data, required BehaviorSubject<List<O>> stream, required Lock lock}) =>
      lock.synchronized<DatabaseResponse<R>>(() async {
        DatabaseResponse<R> response = await execution();
        await _updateStream<O>(data, stream);
        return response;
      });

  Future<void> _updateStream<T>(Future<DatabaseResponse<List<T>>> Function() data, BehaviorSubject<List<T>> stream) async{
    DatabaseResponse<List<T>> response = await data();
    if (response.success) stream.add(notNullOrFail<List<T>>(response.result));
    return;
  }
}
