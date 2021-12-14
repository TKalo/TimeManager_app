import 'dart:math';

import 'package:test/test.dart';
import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/FileStorage.dart';

main() {
  FileStorage storage = FileStorage()..setDebug();

  group('CRUD', () {
    test('Check clean database', () async {
      List<ActivityObject> activities = await storage.getActivities().first;
      expect(activities.length, 0);
    });

    test('test insertion with missing values', () async {
      DateTime startTime = DateTime(2001, 01, 01, 01, 01);
      DateTime endTime = DateTime(2002, 02, 02, 02, 02);
      String category = 'category';
      ActivityObject activity = ActivityObject(starttime: startTime, endtime: endTime, category: category);
      storage.addActivity(activity);
      List<ActivityObject> activities = await storage.getActivities().first;

      expect(activities.length, 1);

      ActivityObject retrievedActivity = activities[0];
      expect(retrievedActivity.id == -1, false);
      expect(retrievedActivity.starttime, startTime);
      expect(retrievedActivity.endtime, retrievedActivity.endtime);
      expect(retrievedActivity.category, category);
      expect(retrievedActivity.description, '');
      expect(retrievedActivity.name, '');
    });

    test('test insertion without missing values', () async {
      int id = -2;
      DateTime startTime = DateTime(2001, 01, 01, 01, 01);
      DateTime endTime = DateTime(2002, 02, 02, 02, 02);
      String category = 'category';
      String name = 'name';
      String description = 'description';
      ActivityObject activity = ActivityObject(id: id, starttime: startTime, endtime: endTime, category: category, name: name, description: description);
      storage.addActivity(activity);
      List<ActivityObject> activities = await storage.getActivities().first;

      expect(activities.length, 1);

      ActivityObject retrievedActivity = activities[0];
      expect(retrievedActivity.id == -1, false);
      expect(retrievedActivity.id == -2, false);
      expect(retrievedActivity.starttime, startTime);
      expect(retrievedActivity.endtime, retrievedActivity.endtime);
      expect(retrievedActivity.category, category);
      expect(retrievedActivity.description, description);
      expect(retrievedActivity.name, name);
    });

    test('update of starttime', () async {
      //Get some activityObject
      ActivityObject activity = (await storage.getActivities().first).first;

      //Change only the starttime
      DateTime newStartTime = activity.starttime.add(const Duration(days: 1, hours: 1, minutes: 1));
      activity.starttime = newStartTime;
      storage.updateActivity(activity);
      ActivityObject newActivity = (await storage.getActivities().first).first;

      //Check that the start time was altered
      expect(newActivity.starttime, newStartTime);

      //Check that no other values where altered
      expect(newActivity.id, activity.id);
      expect(newActivity.endtime, activity.endtime);
      expect(newActivity.category, activity.category);
      expect(newActivity.name, activity.name);
      expect(newActivity.description, activity.description);
    });

    test('update of endtime', () async {
      //Get some activityObject
      ActivityObject activity = (await storage.getActivities().first).first;

      //Change only the endtime
      DateTime newEndTime = activity.endtime.add(const Duration(days: 1, hours: 1, minutes: 1));
      activity.endtime = newEndTime;
      storage.updateActivity(activity);
      ActivityObject newActivity = (await storage.getActivities().first).first;

      //Check that the endtime was altered
      expect(newActivity.endtime, newEndTime);

      //Check that no other values where altered
      expect(newActivity.id, activity.id);
      expect(newActivity.starttime, activity.endtime);
      expect(newActivity.category, activity.category);
      expect(newActivity.name, activity.name);
      expect(newActivity.description, activity.description);
    });

    test('update of category', () async {
      //Get some activityObject
      ActivityObject activity = (await storage.getActivities().first).first;

      //Change only the endtime
      String newCategory = activity.category + ' new';
      activity.category = newCategory;
      storage.updateActivity(activity);
      ActivityObject newActivity = (await storage.getActivities().first).first;

      //Check that the endtime was altered
      expect(newActivity.category, newCategory);

      //Check that no other values where altered
      expect(newActivity.id, activity.id);
      expect(newActivity.starttime, activity.endtime);
      expect(newActivity.endtime, activity.endtime);
      expect(newActivity.name, activity.name);
      expect(newActivity.description, activity.description);
    });

    test('update of description', () async {
      //Get some activityObject
      ActivityObject activity = (await storage.getActivities().first).first;

      //Change only the endtime
      String newDescription = activity.description + ' new';
      activity.description = newDescription;
      storage.updateActivity(activity);
      ActivityObject newActivity = (await storage.getActivities().first).first;

      //Check that the endtime was altered
      expect(newActivity.description, newDescription);

      //Check that no other values where altered
      expect(newActivity.id, activity.id);
      expect(newActivity.starttime, activity.endtime);
      expect(newActivity.endtime, activity.endtime);
      expect(newActivity.name, activity.name);
      expect(newActivity.category, activity.category);
    });

    test('update of name', () async {
      //Get some activityObject
      ActivityObject activity = (await storage.getActivities().first).first;

      //Change only the endtime
      String newName = activity.name + ' new';
      activity.name = newName;
      storage.updateActivity(activity);
      ActivityObject newActivity = (await storage.getActivities().first).first;

      //Check that the endtime was altered
      expect(newActivity.name, newName);

      //Check that no other values where altered
      expect(newActivity.id, activity.id);
      expect(newActivity.starttime, activity.endtime);
      expect(newActivity.endtime, activity.endtime);
      expect(newActivity.description, activity.description);
      expect(newActivity.category, activity.category);
    });

    test('delete all', () async {
      List<ActivityObject> activities = await storage.getActivities().first;

      expect(activities.isEmpty, false);

      activities.forEach((activity) => storage.deleteActivity(activity));
      activities = await storage.getActivities().first;

      expect(activities.length, 0);
    });
  });
}
