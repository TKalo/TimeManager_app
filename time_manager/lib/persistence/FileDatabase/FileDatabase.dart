import 'dart:convert';
import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/DatabaseResponseObject.dart';
import 'package:time_manager/persistence/Interfaces/IBackendDatabase.dart';

import '../../helpers.dart';
import 'FileConnection.dart';

class FileDatabase implements IBackendDatabase {
  final bool debug;
  final FileConnection con;

  String activityObjectsToJson(List<ActivityObject> activities) {
    return jsonEncode(activities.map((activity) => activity.toMap()).toList());
  }

  List<ActivityObject> jsonToActivities(String json) {
    return json == '' ? [] : jsonDecode(json).map<ActivityObject>((e) => ActivityObject.fromJson(e)).toList();
  }

  FileDatabase({required this.debug}) : con = debug ? FileConnection(filename: 'database') : FileConnection(filename: 'test');

  @override
  Future<DatabaseResponseObject<void>> addActivity(ActivityObject activity) async {
    try {
      //get existing activies
      List<ActivityObject> activities = notNullOrFail((await getActivities()).result);

      //set unused id
      activity.id = getUnusedId(activities);

      //add new activity
      activities.add(activity);

      //persist new activity list
      await con.overwriteDatabase(activityObjectsToJson(activities));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  @override
  Future<DatabaseResponseObject> updateActivity(ActivityObject activity) async {
    try {
      //get existing activies
      List<ActivityObject> activities = notNullOrFail((await getActivities()).result);

      //remove old version of activity and add new version
      activities.removeWhere((existingActivity) => existingActivity.id == activity.id);
      activities.add(activity);

      //persist new activity list
      await con.overwriteDatabase(activityObjectsToJson(activities));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  @override
  Future<DatabaseResponseObject> deleteActivity(ActivityObject activity) async {
    try {
      //get existing activies
      List<ActivityObject> activities = notNullOrFail((await getActivities()).result);

      //add new activity
      activities.removeWhere((existingActivity) => existingActivity.id == activity.id);

      //persist new activity list
      await con.overwriteDatabase(activityObjectsToJson(activities));

      return DatabaseResponseObject<void>.success();
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  @override
  Future<DatabaseResponseObject<List<ActivityObject>>> getActivities() async {
    try {
      String json = await con.loadDatabase();

      List<ActivityObject> activities = jsonToActivities(json);

      return DatabaseResponseObject.success(result: activities);
    } catch (e) {
      return DatabaseResponseObject.error(error: e.toString());
    }
  }

  int getUnusedId(List<ActivityObject> activities) {
    int id = 0;

    for (id; id < 10000; id++) if (activities.any((activity) => activity.id == id)) break;

    return id;
  }
}
