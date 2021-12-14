import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:synchronized/synchronized.dart';
import 'package:time_manager/persistence/IStorage.dart';

class FileStorage implements IStorage {
  final _lock = Lock();
  String _filename = 'database.txt';
  final BehaviorSubject<List<ActivityObject>> _data = BehaviorSubject.seeded([]);

  @override
  setDebug() {
    _filename = 'test.txt';
  }

  @override
  void addActivity(ActivityObject object) async {
    await _lock.synchronized(() async {
      List<ActivityObject> data = await _loadDatabase();
      object.id = _findUnusedId(data);
      data.add(object);
      _overwriteDatabase(data);
      _loadDatabaseIntoStream();
    });
  }

  @override
  void deleteActivity(ActivityObject object) async {
    await _lock.synchronized(() async {
      List<ActivityObject> data = await _loadDatabase();
      data.removeWhere((existingObject) => object.id == existingObject.id);
      _overwriteDatabase(data);
      _loadDatabaseIntoStream();
    });
  }

  @override
  Stream<List<ActivityObject>> getActivities() => _data.stream;

  @override
  void updateActivity(ActivityObject object) async {
    await _lock.synchronized(() async {
      List<ActivityObject> data = await _loadDatabase();
      data.removeWhere((existingObject) => object.id == existingObject.id);
      data.add(object);
      _overwriteDatabase(data);
      _loadDatabaseIntoStream();
    });
  }

  void _loadDatabaseIntoStream() async {
    _data.add(await _loadDatabase());
  }

  int _findUnusedId(List<ActivityObject> objects) {
    int id = Random().nextInt(214748364);
    List<int> takenIds = objects.map<int>((object) => object.id).toList();
    while (takenIds.contains(id)) id++;
    return id;
  }

  Future<String> get _localPath async => (await getApplicationDocumentsDirectory()).path;

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/' + _filename);
  }

  Future<List<ActivityObject>> _loadDatabase() async {
    try {
      final file = await _localFile;

      final json = await file.readAsString();

      return (jsonDecode(json).map<ActivityObject>((e) => ActivityObject.fromJson(e)).toList());
    } catch (e) {
      return [];
    }
  }

  _overwriteDatabase(List<ActivityObject> data) async {
    try {
      final file = await _localFile;

      String json = jsonEncode(data.map((object) => object.toMap()).toList());

      file.writeAsString(json);
      // ignore: empty_catches
    } catch (e) {}
  }
}
