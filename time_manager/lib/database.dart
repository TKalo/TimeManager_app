import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_manager/ActivityObject.dart';

Future<String> get _localPath async =>
    (await getApplicationDocumentsDirectory()).path;

Future<File> get _localFile async {
  final path = await _localPath;

  print('FILEPATH: ' + (await _localPath).toString());

  return File('$path/database.txt');
}

Future<List<ActivityObject>> _loadDatabase() async {
  try {
    final file = await _localFile;

    // Read the file
    final json = await file.readAsString();

    print('JSON: ' + json);

    Iterable dynamicList = jsonDecode(json);

    return dynamicList
        .map((dynamic) => ActivityObject.fromMap(Map<String,String>.from(dynamic)))
        .toList();
  } catch (e) {
    // If encountering an error, return 0
    print(e.toString());
    return [];
  }
}

_overwriteDatabase(List<ActivityObject> data) async {
  try {
    final file = await _localFile;

    String json = jsonEncode(data.map((object) => object.toMap()).toList());

    print('WRITE: ' + json);

    // Read the file
    file.writeAsString(json);

    json = jsonEncode(await _loadDatabase());

    print('READ: ' + json);
  } catch (e) {
    // If encountering an error, return 0
    print(e.toString());
    return [];
  }
}

class shared_data {
  static final shared_data _singleton = shared_data._internal();
  factory shared_data() => _singleton;
  shared_data._internal() {
    initial();
  }
  final BehaviorSubject<List<ActivityObject>> _data =
      BehaviorSubject.seeded([]);

  initial() {
    _loadDatabase().then((loadedData) {
      _data.add(loadedData);
      print(loadedData.toString());
    });
    getStream().listen((data) => _overwriteDatabase(data));
  }

  Stream<List<ActivityObject>> getStream() => _data.stream;

  addActivity(ActivityObject object) async =>
      _data.add((await _data.first)..add(object));

  removeActivity(ActivityObject object) async =>
      _data.add((await _data.first)..remove(object));
}
