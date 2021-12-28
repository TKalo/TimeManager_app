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
  static const DatabaseHandler? _singleton = null;
  factory DatabaseHandler({bool debug = false}) => _singleton ?? DatabaseHandler._internal(debug: debug);
  DatabaseHandler._internal({bool debug = false}) : _storage = FileDatabase(debug: debug) {
    _updateStream<Activity>(() => _storage.getActivities(), _activities);
    _updateStream<Category>(() => _storage.getCategories(), _categories);
  }

  final IBackendDatabase _storage;

  final _activityLock = Lock();
  final _categoryLock = Lock();
  final BehaviorSubject<List<Activity>> _activities = BehaviorSubject.seeded([]);
  final BehaviorSubject<List<Category>> _categories = BehaviorSubject.seeded([]);

  @override
  Stream<List<Activity>> getActivities() => _activities.stream;

  @override
  Stream<List<Category>> getCategories() => _categories.stream;

  Future<void> _updateStream<T>(Future<DatabaseResponse<List<T>>> Function() data, BehaviorSubject<List<T>> stream) {
    return _activityLock.synchronized<void>(() async {
      DatabaseResponse<List<T>> response = await data();
      if (response.success) stream.add(notNullOrFail<List<T>>(response.result));
      return;
    });
  }

  @override
  Future<DatabaseResponse<int>> addActivity(Activity activity) {
    return _databaseFunction<Activity, int>(
      execution: () => _storage.addActivity(activity), 
      data: () => _storage.getActivities(), 
      stream: _activities
    );
  }

  @override
  Future<DatabaseResponse<void>> updateActivity(Activity activity) {
    return _databaseFunction<Activity, void>(
      execution: () => _storage.updateActivity(activity), 
      data: () => _storage.getActivities(), 
      stream: _activities
    );
  }

  @override
  Future<DatabaseResponse<void>> deleteActivity(Activity activity) {
    return _databaseFunction<Activity, void>(
      execution: () => _storage.deleteActivity(activity), 
      data: () => _storage.getActivities(), 
      stream: _activities
    );
  }

  @override
  Future<DatabaseResponse<void>> addCategory(Category category) {
    return _databaseFunction<Category, void>(
      execution: () => _storage.addCategory(category), 
      data: () => _storage.getCategories(), 
      stream: _categories
    );
  }

  @override
  Future<DatabaseResponse<void>> deleteCategory(Category category) {
    return _databaseFunction<Category, void>(
      execution: () => _storage.deleteCategory(category), 
      data: () => _storage.getCategories(), 
      stream: _categories
    );
  }

  @override
  Future<DatabaseResponse<void>> updateCategory(Category category) {
    return _databaseFunction<Category, void>(
      execution: () => _storage.updateCategory(category), 
      data: () => _storage.getCategories(), 
      stream: _categories
    );
  }

  Future<DatabaseResponse<R>> _databaseFunction<O, R>(
      {required Future<DatabaseResponse<R>> Function() execution, required Future<DatabaseResponse<List<O>>> Function() data, required BehaviorSubject<List<O>> stream}) {
    return _categoryLock.synchronized<DatabaseResponse<R>>(() async {
      DatabaseResponse<R> response = await execution();
      await _updateStream<Category>(() => _storage.getCategories(), _categories);
      return response;
    });
  }
}
