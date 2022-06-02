import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:time_manager/Database/FileDatabase/ActivityDatabase.dart';
import 'package:time_manager/Database/FileDatabase/FileDatabase.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Utilities/functions.dart';

main() {
  final FileDatabase database = FileDatabase(debug: true);
  final BehaviorSubject<int> testOrder = BehaviorSubject.seeded(1);

  tearDownAll(() async {
    List<Activity> activities = notNullOrFail((await database.getActivities()).result);

    expect(activities.isEmpty, false);
    
    await Future.forEach(activities, (Activity activity) async => await database.deleteActivity(activity));

    expect((await database.getActivities()).result?.length, 0);
  });

  test('Check correct formatting', () {
    Activity activity1 =
        Activity(id: '1', starttime: DateTime(2001, 01, 01, 01, 01), endtime: DateTime(2002, 02, 02, 02, 02), category: 'category1', name: 'name1', description: 'description1');
    Activity activity2 =
        Activity(id: '2', starttime: DateTime(2002, 02, 02, 02, 02), endtime: DateTime(2001, 01, 01, 01, 01), category: 'category2', name: 'name2', description: 'description2');
    List<Activity> activities = [activity1, activity2];

    String json = activityToJson(activities);
    List<Activity> formattedActivities = jsonToActivities(json);

    for (int x = 0; x < activities.length; x++) {
      expect(formattedActivities[x].id, activities[x].id);
      expect(formattedActivities[x].starttime, activities[x].starttime);
      expect(formattedActivities[x].endtime, activities[x].endtime);
      expect(formattedActivities[x].category, activities[x].category);
      expect(formattedActivities[x].name, activities[x].name);
      expect(formattedActivities[x].description, activities[x].description);
    }
  });

  group('CRUD operations', () {
    test('Check clean database', () async => expect((await database.getActivities()).result?.length, 0));

    test('test insertion with missing values', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 1) {
          DateTime startTime = DateTime(2001, 01, 01, 01, 01);
          DateTime endTime = DateTime(2002, 02, 02, 02, 02);
          String category = 'category';
          Activity activity = Activity(starttime: startTime, endtime: endTime, category: category);
          await database.addActivity(activity);

          Activity retrievedActivity = notNullOrFail((await database.getActivities()).result?[0]);
          expect(retrievedActivity.id == -1, false);
          expect(retrievedActivity.starttime, startTime);
          expect(retrievedActivity.endtime, retrievedActivity.endtime);
          expect(retrievedActivity.category, category);
          expect(retrievedActivity.description, '');
          expect(retrievedActivity.name, '');
          sub?.cancel();
          testOrder.add(2);
        }
      });
    });

    test('test insertion without missing values', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 2) {
          String id = '-2';
          DateTime startTime = DateTime(2001, 01, 01, 01, 01);
          DateTime endTime = DateTime(2002, 02, 02, 02, 02);
          String category = 'category';
          String name = 'name';
          String description = 'description';
          Activity activity = Activity(id: id, starttime: startTime, endtime: endTime, category: category, name: name, description: description);
          await database.addActivity(activity);

          Activity retrievedActivity = notNullOrFail((await database.getActivities()).result?[1]);
          expect(retrievedActivity.id == -1, false);
          expect(retrievedActivity.id == -2, false);
          expect(retrievedActivity.starttime, startTime);
          expect(retrievedActivity.endtime, retrievedActivity.endtime);
          expect(retrievedActivity.category, category);
          expect(retrievedActivity.description, description);
          expect(retrievedActivity.name, name);
          sub?.cancel();
          testOrder.add(3);
        }
      });
    });

    test('update of starttime', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 3) {
          //Get some activityObject
          Activity activity = notNullOrFail((await database.getActivities()).result?[1]);

          //Change only the starttime
          DateTime newStartTime = activity.starttime.add(const Duration(days: 1, hours: 1, minutes: 1));
          activity.starttime = newStartTime;
          await database.updateActivity(activity);

          Activity newActivity = notNullOrFail((await database.getActivities()).result?[1]);

          //Check that the start time was altered
          expect(newActivity.starttime, newStartTime);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.category, activity.category);
          expect(newActivity.name, activity.name);
          expect(newActivity.description, activity.description);
          sub?.cancel();
          testOrder.add(4);
        }
      });
    });

    test('update of endtime', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 4) {
          //Get some activityObject
          Activity activity = notNullOrFail((await database.getActivities()).result?[1]);

          //Change only the endtime
          DateTime newEndTime = activity.endtime.add(const Duration(days: 1, hours: 1, minutes: 1));
          activity.endtime = newEndTime;
          await database.updateActivity(activity);

          Activity newActivity = notNullOrFail((await database.getActivities()).result?[1]);

          //Check that the endtime was altered
          expect(newActivity.endtime, newEndTime);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.starttime);
          expect(newActivity.category, activity.category);
          expect(newActivity.name, activity.name);
          expect(newActivity.description, activity.description);
          sub?.cancel();
          testOrder.add(5);
        }
      });
    });

    test('update of category', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 5) {
          //Get some activityObject
          Activity activity = notNullOrFail((await database.getActivities()).result?[1]);

          //Change only the endtime
          String newCategory = activity.category + ' new';
          activity.category = newCategory;
          await database.updateActivity(activity);

          Activity newActivity = notNullOrFail((await database.getActivities()).result?[1]);

          //Check that the endtime was altered
          expect(newActivity.category, newCategory);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.starttime);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.name, activity.name);
          expect(newActivity.description, activity.description);
          sub?.cancel();
          testOrder.add(6);
        }
      });
    });

    test('update of description', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 6) {
          //Get some activityObject
          Activity activity = notNullOrFail((await database.getActivities()).result?[1]);

          //Change only the endtime
          String newDescription = activity.description + ' new';
          activity.description = newDescription;
          await database.updateActivity(activity);

          Activity newActivity = notNullOrFail((await database.getActivities()).result?[1]);

          //Check that the endtime was altered
          expect(newActivity.description, newDescription);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.starttime);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.name, activity.name);
          expect(newActivity.category, activity.category);
          sub?.cancel();
          testOrder.add(7);
        }
      });
    });

    test('update of name', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 7) {
          //Get some activityObject
          Activity activity = notNullOrFail((await database.getActivities()).result?[1]);

          //Change only the endtime
          String newName = activity.name + ' new';
          activity.name = newName;
          await database.updateActivity(activity);

          Activity newActivity = notNullOrFail((await database.getActivities()).result?[1]);

          //Check that the endtime was altered
          expect(newActivity.name, newName);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.starttime);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.description, activity.description);
          expect(newActivity.category, activity.category);

          sub?.cancel();
          testOrder.close();
        }
      });
    });
  });
}
