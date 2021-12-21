import 'package:test/test.dart';
import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/DatabaseResponseObject.dart';
import 'package:time_manager/persistence/FileDatabase/FileDatabase.dart';

main() {
  FileDatabase database = FileDatabase(debug: true);

  test('Check correct formatting', () {
    ActivityObject activity1 =
        ActivityObject(id: 1, starttime: DateTime(2001, 01, 01, 01, 01), endtime: DateTime(2002, 02, 02, 02, 02), category: 'category1', name: 'name1', description: 'description1');
    ActivityObject activity2 =
        ActivityObject(id: 2, starttime: DateTime(2002, 02, 02, 02, 02), endtime: DateTime(2001, 01, 01, 01, 01), category: 'category2', name: 'name2', description: 'description2');
    List<ActivityObject> activities = [activity1, activity2];

    String json = database.activityObjectsToJson(activities);
    List<ActivityObject> formattedActivities = database.jsonToActivities(json);

    for (int x = 0; x < activities.length; x++) {
      expect(formattedActivities[x].id, activities[x].id);
      expect(formattedActivities[x].starttime, activities[x].starttime);
      expect(formattedActivities[x].endtime, activities[x].endtime);
      expect(formattedActivities[x].category, activities[x].category);
      expect(formattedActivities[x].name, activities[x].name);
      expect(formattedActivities[x].description, activities[x].description);
    }
  });

  test('Check clean database', () async {
    DatabaseResponseObject<List<ActivityObject>> response = await database.getActivities();

    expect(response.success, true);
    expect(response.result != null, true);
    expect(response.result?.length, 0);
  });

  test('test insertion with missing values', () async {
    DateTime startTime = DateTime(2001, 01, 01, 01, 01);
    DateTime endTime = DateTime(2002, 02, 02, 02, 02);
    String category = 'category';
    ActivityObject activity = ActivityObject(starttime: startTime, endtime: endTime, category: category);
    await database.addActivity(activity);

    DatabaseResponseObject<List<ActivityObject>> response = await database.getActivities();

    expect(response.success, true);
    expect(response.result != null, true);
    expect(response.result?.length, 1);

    ActivityObject retrievedActivity = response.result?[0] ?? activity;
    expect(retrievedActivity.id == -1, false);
    expect(retrievedActivity.starttime, startTime);
    expect(retrievedActivity.endtime, retrievedActivity.endtime);
    expect(retrievedActivity.category, category);
    expect(retrievedActivity.description, '');
    expect(retrievedActivity.name, '');
  });

  test('delete all', () async {
    DatabaseResponseObject<List<ActivityObject>> response = await database.getActivities();

    expect(response.success, true);
    expect(response.result != null, true);
    expect(response.result?.isEmpty, false);

    List<ActivityObject> activities = response.result ?? [];
    
    await Future.forEach(activities, (ActivityObject activity) async => await database.deleteActivity(activity));

    response = await database.getActivities();

    expect(response.success, true);
    expect(response.result != null, true);
    expect(response.result?.length, 0);
  });
}
