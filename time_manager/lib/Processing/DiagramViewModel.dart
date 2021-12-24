import 'package:time_manager/persistence/Objects/ActivityObject.dart';

import 'ActivityManipulation.dart';

class DiagramViewModel {
  static final DiagramViewModel _singleton = DiagramViewModel._internal();
  factory DiagramViewModel() => _singleton;
  DiagramViewModel._internal();

  processData(List<ActivityObject> activities, DateTime date) {
    activities = getActivitiesOfDay(activities, date);

    ActivityObject defaultActivity = ActivityObject(starttime: DateTime(date.year, date.month, date.day, 0, 0), endtime: DateTime(date.year, date.month, date.day, 23, 59), category: 'default');

    activities = activities..addAll(cropSingleActivity(activities, defaultActivity));

    sortActivitiesByDateTime(activities);

    return activities;
  }
}
