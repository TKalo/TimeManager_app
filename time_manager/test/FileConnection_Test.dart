import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:time_manager/Database/FileDatabase/file_connection.dart';

main() {
  String filename = 'random_file';
  FileConnection connection = FileConnection(filename: filename);

  test('test file does not exist', () async {
    String path = (await getApplicationDocumentsDirectory()).path;
    expect(await File(path + '/' + filename).exists(), false);
  });

  test('test empty file', () async {
    String fileContent = await connection.loadDatabase();
    expect(fileContent, '');
  });

  test('test writing to file', () async {
    String content = 'content';
    await connection.overwriteDatabase(content);
    String fileContent = await connection.loadDatabase();
    expect(fileContent, content);
  });

  test('test overwriting content to file', () async {
    String overwritingContent = 'overwritingContent';
    await connection.overwriteDatabase(overwritingContent);
    String fileContent = await connection.loadDatabase();
    expect(fileContent, overwritingContent);
  });

  test('test file deletion', () async {
    String path = (await getApplicationDocumentsDirectory()).path;
    expect(await File(path + '/' + filename).exists(), true);
    await connection.deleteFile();
    expect(await File(path + '/' + filename).exists(), false);
  });
}
