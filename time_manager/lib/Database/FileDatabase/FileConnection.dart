import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileConnection {
  final String filename;
  File? file;

  FileConnection({required this.filename});

  Future<String> get _localPath async => (await getApplicationDocumentsDirectory()).path;

  Future<File> get _localFile async => file ?? (file = await File((await _localPath) + '/' + filename).create());

  Future<String> loadDatabase() async => (await _localFile).readAsStringSync();

  Future<void> overwriteDatabase(String json) async => (await _localFile).writeAsString(json);

  Future<void> deleteFile() async => {(await _localFile).deleteSync()};
}
