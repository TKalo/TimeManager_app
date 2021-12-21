import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/DatabaseHandler.dart';

main() {
  DatabaseHandler database = DatabaseHandler(debug: true);
  setUp(() async {
    await database.updateStream();
    sleep(const Duration(seconds: 2));
    List<ActivityObject> activities = notNullOrFail(await database.getActivities().first);
    await Future.forEach(activities, (ActivityObject activity) async => await database.deleteActivity(activity));
  });

  test('DatabaseHandler', () async {
    //TEST DATABASE EMPTY
    List<ActivityObject> activities = await database.getActivities().first;
    expect(activities.length, 0, reason: 'database initially not empty');

    //TEST ADDACTIVITY
    DateTime startTime = DateTime(2001, 01, 01, 01, 01);
    DateTime endTime = DateTime(2002, 02, 02, 02, 02);
    String category = 'category';
    ActivityObject activity = ActivityObject(starttime: startTime, endtime: endTime, category: category);
    await database.addActivity(activity);

    activities = notNullOrFail(await database.getActivities().first);
    expect(activities.length, 1, reason: 'activity not added');

    ActivityObject retrievedActivity = activities[0];
    expect(retrievedActivity.id == -1, false);
    expect(retrievedActivity.starttime, startTime);
    expect(retrievedActivity.endtime, retrievedActivity.endtime);
    expect(retrievedActivity.category, category);
    expect(retrievedActivity.description, '');
    expect(retrievedActivity.name, '');

    //TEST UPDATEACTIVITY
    String newName = activity.name + ' new';
    activity.name = newName;
    await database.updateActivity(activity);

    activities = notNullOrFail(await database.getActivities().first);

    expect(activities.length, 1);

    retrievedActivity = activities[1];

    expect(retrievedActivity.name, newName);

    expect(retrievedActivity.id, activity.id);
    expect(retrievedActivity.starttime, activity.endtime);
    expect(retrievedActivity.endtime, activity.endtime);
    expect(retrievedActivity.description, activity.description);
    expect(retrievedActivity.category, activity.category);

    //TEST DELETEACTIVITY
    await database.deleteActivity(retrievedActivity);

    activities = notNullOrFail(await database.getActivities().first);

    expect(activities.length, 0);
  });
}
