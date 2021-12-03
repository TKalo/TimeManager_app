import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_manager/ActivityObject.dart';
import 'package:synchronized/synchronized.dart';

class Model {
  static final Model _singleton = Model._internal();
  factory Model() => _singleton;
  Model._internal() {
    _loadDatabase().then((loadedData) => _data.add(loadedData));
  }

  final BehaviorSubject<List<ActivityObject>> _data = BehaviorSubject.seeded([]);
  final BehaviorSubject<int> _dayOffset = BehaviorSubject.seeded(0);
  String filename = 'database.txt';

  Stream<List<ActivityObject>> getStream() => _data.stream;
  Stream<int> getDayOffsetStream() => _dayOffset.stream;

  setDebug() {
    filename = 'test.txt';
    _loadDatabase().then((loadedData) => _data.add(loadedData));
  }

  addActivity(ActivityObject object) async {
    var lock = Lock();
    await lock.synchronized(() async {
      List<ActivityObject> newList = (await _data.first)..add(object);
      _data.add(newList);
      _overwriteDatabase(newList);
    });
    
  }

  removeActivity(ActivityObject object) async {
    List<ActivityObject> newList = (await _data.first)..remove(object);
    _data.add(newList);
    _overwriteDatabase(newList);
  }

  increaseDayOffset() async {
    int newOffset = (await _dayOffset.first) + 1;
    _dayOffset.add(newOffset);
  }

  reduceDayOffset() async {
    int newOffset = (await _dayOffset.first) - 1;
    _dayOffset.add(newOffset);
  }

  Future<String> get _localPath async => (await getApplicationDocumentsDirectory()).path;

  Future<File> get _localFile async {
    final path = await _localPath;

    return File('$path/' + filename);
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
