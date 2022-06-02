import 'dart:convert';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';
import 'package:time_manager/Utilities/functions.dart';

import 'file_connection.dart';

class ActivityDatabase {
  final FileConnection connection;

  ActivityDatabase({required this.connection});

  Future<DatabaseResponse<String>> addActivity(Activity activity) async {
    try {
      //get existing activies
      List<Activity> activities = notNullOrFail((await getActivities()).result);

      //set unused id
      activity.id = getUnusedId(activities);

      //add new activity
      activities.add(activity);

      //persist new activity list
      await connection.overwriteDatabase(activityToJson(activities));

      return DatabaseResponse<String>.success(result: activity.id);
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }

  Future<DatabaseResponse> updateActivity(Activity activity) async {
    try {
      //get existing activies
      List<Activity> activities = notNullOrFail((await getActivities()).result);

      //remove old version of activity and add new version
      activities.removeWhere((existingActivity) => existingActivity.id == activity.id);
      activities.add(activity);

      //persist new activity list
      await connection.overwriteDatabase(activityToJson(activities));

      return DatabaseResponse<void>.success();
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }

  Future<DatabaseResponse> deleteActivity(Activity activity) async {
    try {
      //get existing activies
      List<Activity> activities = notNullOrFail((await getActivities()).result);

      //add new activity
      activities.removeWhere((existingActivity) => existingActivity.id == activity.id);

      //persist new activity list
      await connection.overwriteDatabase(activityToJson(activities));

      return DatabaseResponse<void>.success();
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }


  Future<DatabaseResponse<List<Activity>>> getActivities() async {
    try {
      String json = await connection.loadDatabase();

      List<Activity> activities = jsonToActivities(json);

      return DatabaseResponse.success(result: activities);
    } catch (e) {
      return DatabaseResponse.error(error: e.toString());
    }
  }

  String getUnusedId(List<Activity> activities) {
    int id = 0;

    for (id; id < 10000; id++) if (!activities.any((activity) => activity.id == id.toString())) break;

    return id.toString();
  }

}

String activityToJson(List<Activity> activities) => jsonEncode(activities.map((activity) => activity.toMap()).toList());
List<Activity> jsonToActivities(String json) => json == '' ? [] : jsonDecode(json).map<Activity>((e) => Activity.fromJson(e)).toList();