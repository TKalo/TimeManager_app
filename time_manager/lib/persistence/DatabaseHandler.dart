import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';
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
    updateStream();
  }

  final _lock = Lock();
  final BehaviorSubject<List<ActivityObject>> _data = BehaviorSubject.seeded([]);
  final bool debug;
  final IBackendDatabase storage;

  @override
  Future<DatabaseResponseObject<int>> addActivity(ActivityObject activity) {
    return _lock.synchronized<DatabaseResponseObject<int>>(() {
      updateStream();
      return storage.addActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> updateActivity(ActivityObject activity) {
    return _lock.synchronized<DatabaseResponseObject<void>>(() {
      updateStream();
      return storage.updateActivity(activity);
    });
  }

  @override
  Future<DatabaseResponseObject<void>> deleteActivity(ActivityObject activity) {
    return _lock.synchronized<DatabaseResponseObject<void>>(() {
      updateStream();
      return storage.deleteActivity(activity);
    });
  }

  @override
  Stream<List<ActivityObject>> getActivities() => _data.stream;

  Future<void> updateStream() {
    return _lock.synchronized<void>(() async {
      DatabaseResponseObject<List<ActivityObject>> response = await storage.getActivities();
      if (response.success) _data.add(notNullOrFail<List<ActivityObject>>(response.result));
      return;
    });
  }
}
