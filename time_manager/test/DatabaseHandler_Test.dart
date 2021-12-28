import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:time_manager/Database/DatabaseHandler.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Utilities/Functions.dart';

main() {
  DatabaseHandler database = DatabaseHandler(debug: true);
  setUp(() async {
    sleep(const Duration(seconds: 2));
    List<Activity> activities = notNullOrFail(await database.getActivities().first);
    await Future.forEach(activities, (Activity activity) async => await database.deleteActivity(activity));
    sleep(const Duration(seconds: 2));
  });

  tearDown(() async {
    List<Activity> activities = notNullOrFail(await database.getActivities().first);
    await Future.forEach(activities, (Activity activity) async => await database.deleteActivity(activity));
  });

  test('DatabaseHandler', () async {

    //TEST DATABASE EMPTY
    List<Activity> activities = await database.getActivities().first;
    expect(activities.length, 0, reason: 'database initially not empty');

    //TEST ADDACTIVITY
    DateTime startTime = DateTime(2001, 01, 01, 01, 01);
    DateTime endTime = DateTime(2002, 02, 02, 02, 02);
    String category = 'category';
    Activity activity = Activity(starttime: startTime, endtime: endTime, category: category);
    await database.addActivity(activity);

    activities = notNullOrFail(await database.getActivities().first);
    expect(activities.length, 1, reason: 'activity not added');

    Activity retrievedActivity = activities[0];
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
