import 'dart:convert';

import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Objects/DatabaseResponseObject.dart';

import '../../helpers.dart';
import 'FileConnection.dart';

class ActivityDatabase {
  final FileConnection connection;

  String activityObjectsToJson(List<ActivityObject> activities) => jsonEncode(activities.map((activity) => activity.toMap()).toList());

  List<ActivityObject> jsonToActivities(String json) => json == '' ? [] : jsonDecode(json).map<ActivityObject>((e) => ActivityObject.fromJson(e)).toList();

  ActivityDatabase({required this.connection});

  Future<DatabaseResponseObject<int>> addActivity(ActivityObject activity) async {
    try {
      //get existing activies
      List<ActivityObject> activities = notNullOrFail((await getActivities()).result);

      //set unused id
      activity.id = getUnusedId(activities);

      //add new activity
      activities.add(activity);

      //persist new activity list
      await connection.overwriteDatabase(activityObjectsToJson(activities));

      return DatabaseResponseObject<int>.success(result: activity.id);
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  Future<DatabaseResponseObject> updateActivity(ActivityObject activity) async {
    try {
      //get existing activies
      List<ActivityObject> activities = notNullOrFail((await getActivities()).result);

      //remove old version of activity and add new version
      activities.removeWhere((existingActivity) => existingActivity.id == activity.id);
      activities.add(activity);

      //persist new activity list
      await connection.overwriteDatabase(activityObjectsToJson(activities));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  Future<DatabaseResponseObject> deleteActivity(ActivityObject activity) async {
    try {
      //get existing activies
      List<ActivityObject> activities = notNullOrFail((await getActivities()).result);

      //add new activity
      activities.removeWhere((existingActivity) => existingActivity.id == activity.id);

      //persist new activity list
      await connection.overwriteDatabase(activityObjectsToJson(activities));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }


  Future<DatabaseResponseObject<List<ActivityObject>>> getActivities() async {
    try {
      String json = await connection.loadDatabase();

      List<ActivityObject> activities = jsonToActivities(json);

      return DatabaseResponseObject.success(result: activities);
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  int getUnusedId(List<ActivityObject> activities) {
    int id = 0;

    for (id; id < 10000; id++) if (!activities.any((activity) => activity.id == id)) break;

    return id;
  }

}
