import 'package:test/test.dart';
import 'package:time_manager/ActivityObject.dart';
import 'package:time_manager/Model.dart';

void main(List<String> args) {
  Model model = Model();

  setUp(() {
    model.setDebug();
  });

  test('test initial database is empty', () {
    expect(() async => (await model.getStream().first).length, 0);
  });

  test('test addition of activityobject with empty values', () {
    ActivityObject object = ActivityObject(starttime: DateTime(2001, 01, 01, 01, 01), endtime: DateTime(2002, 02, 02, 02, 02), category: 'category');
    model.addActivity(object);
    expect(() async => (await model.getStream().first), object);
  });

  test('test addition of Activityobject with non empty values', () {
    ActivityObject object = ActivityObject(starttime: DateTime(2000, 01, 01, 01, 01), endtime: DateTime(2002, 02, 02, 02, 02), category: 'category', name: 'name', description: 'description');
    model.addActivity(object);
    expect(() async => (await model.getStream().first), object);
  });
}
