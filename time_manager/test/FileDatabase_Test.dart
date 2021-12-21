import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:test/test.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';
import 'package:time_manager/persistence/FileDatabase/FileDatabase.dart';

main() {
  FileDatabase database = FileDatabase(debug: true);
  final BehaviorSubject<int> testOrder = BehaviorSubject.seeded(0);

  group('FileDatabase Tests', () {
    test('Check correct formatting', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) {
        if (order == 0) {
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
          sub?.cancel();
          testOrder.add(1);
        }
      });
    });

    test('Check clean database', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async{
        if (order == 1) {
          DatabaseResponseObject<List<ActivityObject>> response = await database.getActivities();

          expect(response.success, true);
          expect(response.result != null, true);
          expect(response.result?.length, 0);
          sub?.cancel();
          testOrder.add(2);
        }
      });
    });

    test('test insertion with missing values', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 2) {
          DateTime startTime = DateTime(2001, 01, 01, 01, 01);
          DateTime endTime = DateTime(2002, 02, 02, 02, 02);
          String category = 'category';
          ActivityObject activity = ActivityObject(starttime: startTime, endtime: endTime, category: category);
          await database.addActivity(activity);

          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          ActivityObject retrievedActivity = activities[0];
          expect(retrievedActivity.id == -1, false);
          expect(retrievedActivity.starttime, startTime);
          expect(retrievedActivity.endtime, retrievedActivity.endtime);
          expect(retrievedActivity.category, category);
          expect(retrievedActivity.description, '');
          expect(retrievedActivity.name, '');
          sub?.cancel();
          testOrder.add(3);
        }
      });
    });

    test('test insertion without missing values', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 3) {
          int id = -2;
          DateTime startTime = DateTime(2001, 01, 01, 01, 01);
          DateTime endTime = DateTime(2002, 02, 02, 02, 02);
          String category = 'category';
          String name = 'name';
          String description = 'description';
          ActivityObject activity = ActivityObject(id: id, starttime: startTime, endtime: endTime, category: category, name: name, description: description);
          await database.addActivity(activity);

          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject retrievedActivity = activities[1];
          expect(retrievedActivity.id == -1, false);
          expect(retrievedActivity.id == -2, false);
          expect(retrievedActivity.starttime, startTime);
          expect(retrievedActivity.endtime, retrievedActivity.endtime);
          expect(retrievedActivity.category, category);
          expect(retrievedActivity.description, description);
          expect(retrievedActivity.name, name);
          sub?.cancel();
          testOrder.add(4);
        }
      });
    });

    test('update of starttime', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 4) {
          //Get some activityObject
          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject activity = activities[1];

          //Change only the starttime
          DateTime newStartTime = activity.starttime.add(const Duration(days: 1, hours: 1, minutes: 1));
          activity.starttime = newStartTime;
          await database.updateActivity(activity);

          activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject newActivity = activities[1];

          //Check that the start time was altered
          expect(newActivity.starttime, newStartTime);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.category, activity.category);
          expect(newActivity.name, activity.name);
          expect(newActivity.description, activity.description);
          sub?.cancel();
          testOrder.add(5);
        }
      });
    });

    test('update of endtime', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 5) {
          //Get some activityObject
          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject activity = activities[1];

          //Change only the endtime
          DateTime newEndTime = activity.endtime.add(const Duration(days: 1, hours: 1, minutes: 1));
          activity.endtime = newEndTime;
          await database.updateActivity(activity);

          activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject newActivity = activities[1];
          //Check that the endtime was altered
          expect(newActivity.endtime, newEndTime);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.endtime);
          expect(newActivity.category, activity.category);
          expect(newActivity.name, activity.name);
          expect(newActivity.description, activity.description);
          sub?.cancel();
          testOrder.add(6);
        }
      });
    });

    test('update of category', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 6) {
          //Get some activityObject
          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject activity = activities[1];

          //Change only the endtime
          String newCategory = activity.category + ' new';
          activity.category = newCategory;
          await database.updateActivity(activity);

          activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject newActivity = activities[1];

          //Check that the endtime was altered
          expect(newActivity.category, newCategory);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.endtime);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.name, activity.name);
          expect(newActivity.description, activity.description);
          sub?.cancel();
          testOrder.add(7);
        }
      });
    });

    test('update of description', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 7) {
          //Get some activityObject
          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject activity = activities[1];

          //Change only the endtime
          String newDescription = activity.description + ' new';
          activity.description = newDescription;
          await database.updateActivity(activity);

          activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject newActivity = activities[1];

          //Check that the endtime was altered
          expect(newActivity.description, newDescription);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.endtime);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.name, activity.name);
          expect(newActivity.category, activity.category);
          sub?.cancel();
          testOrder.add(8);
        }
      });
    });

    test('update of name', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {

        if (order == 8) {
          //Get some activityObject
          List<ActivityObject> activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject activity = activities[1];

          //Change only the endtime
          String newName = activity.name + ' new';
          activity.name = newName;
          await database.updateActivity(activity);

          activities = notNullOrFail((await database.getActivities()).result);

          expect(activities.length, 2);

          ActivityObject newActivity = activities[1];

          //Check that the endtime was altered
          expect(newActivity.name, newName);

          //Check that no other values where altered
          expect(newActivity.id, activity.id);
          expect(newActivity.starttime, activity.endtime);
          expect(newActivity.endtime, activity.endtime);
          expect(newActivity.description, activity.description);
          expect(newActivity.category, activity.category);
          
          sub?.cancel();
          testOrder.add(9);
        }
      });
    });

    test('delete all', () {
      StreamSubscription? sub;
      sub = testOrder.stream.listen((order) async {
        if (order == 9) {
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
          sub?.cancel();
          testOrder.close();
        }
      });
    });
  });
}
