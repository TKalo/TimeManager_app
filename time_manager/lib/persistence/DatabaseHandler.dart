import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_manager/persistence/DatabaseResponseObject.dart';
import 'package:time_manager/persistence/FileDatabase/FileDatabase.dart';
import 'package:time_manager/persistence/Interfaces/IBackendDatabase.dart';
import 'package:time_manager/persistence/Interfaces/IFrontendDatabase.dart';

import '../helpers.dart';
import 'ActivityObject.dart';

class DatabaseHandler implements IFrontendDatabase {
  static final DatabaseHandler _singleton = DatabaseHandler._internal();
  factory DatabaseHandler() => _singleton;
  DatabaseHandler._internal({this.debug = false}) : storage = FileDatabase(debug: debug);

  final _lock = Lock();
  final BehaviorSubject<List<ActivityObject>> _data = BehaviorSubject.seeded([]);
  final bool debug;
  final IBackendDatabase storage;

  @override
  Future<DatabaseResponseObject<void>> addActivity(ActivityObject activity) {
    return _lock.synchronized<DatabaseResponseObject<void>>(() {
      _updateStream();
      return storage.addActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject activity) {
    return _lock.synchronized<DatabaseResponseObject<void>>(() {
      _updateStream();
      return storage.updateActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject activity) {
    return _lock.synchronized<DatabaseResponseObject<void>>(() {
      _updateStream();
      return storage.deleteActivity(activity);
    });
  }

  @override
  Stream<List<ActivityObject>> getActivities() => _data.stream;

  void _updateStream() {
    _lock.synchronized(() async {
      DatabaseResponseObject<List<ActivityObject>> response = await storage.getActivities();
      if (response.success) _data.add(notNullOrFail<List<ActivityObject>>(response.result));
    });
  }
}
