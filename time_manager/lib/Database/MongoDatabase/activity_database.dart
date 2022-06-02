import 'dart:collection';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';

class ActivityDatabase {
  Future<Db> db;
  Future<DbCollection> collection;
  ActivityDatabase({required this.db}) : collection = db.then((db) => db.collection('activities'));

  Future<DatabaseResponse<String>> add(Activity activity) async {
    final col = await collection;

    final map = await col.insert(activity.toMap());

    map.addAll({'_id': ObjectId().toString()});

    activity = Activity.fromJson(map);

    return DatabaseResponse.success(result: activity.id);
  }

  Future<DatabaseResponse<void>> update(Activity activity) async {
    final col = await collection;

    activity.toMap().forEach((k, v) {
      if (k == '_id') return;

      col.update(where.eq('_id', activity.id), modify.set(k, v));
    });

    return DatabaseResponse.success(result: null);
  }

  Future<DatabaseResponse<List<Activity>>> get() async {
    final col = await collection;

    List<Activity> activities = await col.find().map((activity) => Activity.fromJson(activity)).toList();

    return DatabaseResponse.success(result: activities);
  }

  Future<DatabaseResponse<void>> delete(Activity activity) async {
    final col = await collection;

    col.remove(where.eq('_id', activity.id));

    return DatabaseResponse.success(result: null);
  }
}
