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

    return (jsonDecode(json).map<ActivityObject>((e) => ActivityObject.fromJson(e)).toList());
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

    print('READ: ' + json.toString());
  } catch (e) {
    // If encountering an error, return 0
    print(e.toString());
    return [];
  }
}

class shared_data {
  static final shared_data _singleton = shared_data._internal();
  factory shared_data() => _singleton;
  shared_data._internal() {initial();}
  final BehaviorSubject<List<ActivityObject>> _data = BehaviorSubject.seeded([]);
  final BehaviorSubject<int> _dayOffset = BehaviorSubject.seeded(0);

  initial() {
    _loadDatabase().then((loadedData) {
      _data.add(loadedData);
      print(loadedData.toString());
    });

  }

  Stream<List<ActivityObject>> getStream() => _data.stream;
  Stream<int> getDayOffsetStream() => _dayOffset.stream;

  addActivity(ActivityObject object) async {
    List<ActivityObject> newList = (await _data.first)..add(object);
    _data.add(newList);
    _overwriteDatabase(newList);
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
}
