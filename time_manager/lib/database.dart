import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:time_manager/ActivityObject.dart';

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/database.txt');
}

Future<List<ActivityObject>> _loadDatabase() async {
  try {
    final file = await _localFile;

    // Read the file
    final json = await file.readAsString();

    List<Map<String, String>> rawObjects = jsonDecode(json);

    return rawObjects.map((map) => ActivityObject.fromMap(map)).toList();
  } catch (e) {
    // If encountering an error, return 0
    log(e.toString());
    return [];
  }
}

_overwriteDatabase(List<ActivityObject> data) async {
  try {
    final file = await _localFile;

    // Read the file
    file.writeAsString(
        jsonEncode(data.map((object) => object.toMap()).toList()));
  } catch (e) {
    // If encountering an error, return 0
    log(e.toString());
    return [];
  }
}

StreamController<List<ActivityObject>> _data = StreamController.broadcast();

class Database {
  static final Database _singleton = Database._internal();
  factory Database() => _singleton;

  Database._internal() {
    _data.add([]);
    _loadDatabase().then((loadedData) => _data.add(loadedData));
    getStream().listen((data) => _overwriteDatabase(data));

    getStream().listen((event) => print('DATA: ' + event.length.toString()));
  }

  Stream<List<ActivityObject>> getStream() => _data.stream;

  addToDatabase(ActivityObject object) async {
    print(object.toMap());
    _data.add([object,object]);
  }
}
