import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Utilities/Pair.dart';
import 'package:time_manager/Utilities/helpers.dart';

import '../Utilities/ActivityManipulation.dart';

class DiagramViewModel {
  static final DiagramViewModel _singleton = DiagramViewModel._internal();
  factory DiagramViewModel() => _singleton;
  DiagramViewModel._internal();

  List<Pair<ActivityObject, Color>> processData(List<ActivityObject> activities, DateTime date, List<CategoryObject> categories) {
    activities = getActivitiesOfDay(activities, date);

    ActivityObject defaultActivity = ActivityObject(starttime: DateTime(date.year, date.month, date.day, 0, 0), endtime: DateTime(date.year, date.month, date.day, 23, 59), category: 'default');

    activities = activities..addAll(cropSingleActivity(activities, defaultActivity));

    sortActivitiesByDateTime(activities);

    return activities.map((activity) => Pair(first: activity, last: categories.firstWhere((category) => category.name == activity.category, orElse: () => CategoryObject(name: '', color: Colors.grey)).color)).toList();
  }
}
