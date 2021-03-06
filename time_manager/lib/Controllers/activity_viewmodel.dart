import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:time_manager/Database/database_handler.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';
import 'package:time_manager/Controllers/main_viewmodel.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:time_manager/Utilities/functions.dart';
import 'package:time_manager/Utilities/objects.dart';

class ActivityViewModel {
  static final ActivityViewModel _singleton = ActivityViewModel._internal();
  factory ActivityViewModel() => _singleton;
  ActivityViewModel._internal();

  Activity activity = Activity(starttime: DateTime.now(), endtime: DateTime.now(), category: '');
  final BehaviorSubject<String?> _globalError = BehaviorSubject();

  void deleteActivity(Activity activity) => DatabaseHandler().deleteActivity(activity);

  void _resetActivity() => activity = Activity(starttime: DateTime.now(), endtime: DateTime.now(), category: '');

  Future<String> pickTime(BuildContext context) async {
    TimeRange interval = await showTimeRangePicker(
        context: context, interval: const Duration(minutes: 5), disabledTime: TimeRange(startTime: const TimeOfDay(hour: 0, minute: 0), endTime: const TimeOfDay(hour: 0, minute: 0)));

    DateTime selectedDate = await MainViewModel().getFocusDay().first;

    activity.starttime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, interval.startTime.hour, interval.startTime.minute);

    activity.endtime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, interval.endTime.hour, interval.endTime.minute);

    return timeOfDayToTimeString(interval.startTime) + " - " + timeOfDayToTimeString(interval.endTime);
  }

  void submitActivity(BuildContext context) async {
    List<Activity> allActivities = await DatabaseHandler().getActivities().first;

    List<Activity> selectedDateActivities = getActivitiesOfDay(allActivities, activity.starttime);

    List<Activity> intersectingActivities = getIntersectingActivities(selectedDateActivities, activity);

    if (intersectingActivities.isNotEmpty) {
      _requestActivityConflictResolution(context, intersectingActivities);
    } else {
      _persistActivities([activity], context);
    }
  }

  void _requestActivityConflictResolution(BuildContext context, List<Activity> intersectingActivities) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('other activities intersect the selected time interval'),
            actions: [
              TextButton(onPressed: () => _persistActivities(cropSingleActivity(intersectingActivities, activity), context), child: const Text('crop this activity')),
              TextButton(
                  onPressed: () {
                    _persistActivities([activity, ...cropListOfActivities(intersectingActivities, activity)], context);
                    intersectingActivities.forEach((intersectingActivity) => deleteActivity(intersectingActivity));
                  },
                  child: const Text('crop other activities')),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('cancel'))
            ],
          );
        });
  }

  void _persistActivities(List<Activity> activities, BuildContext context) async {
    String? error;
    for (Activity activity in activities) {
      DatabaseResponse<String> response = await DatabaseHandler().addActivity(activity);

      if (response.success) {
        activity.id = response.result ?? '';
      } else {
        error = response.error;
        break;
      }
    }

    if (error != null) {
      String? rollbackError;

      for (Activity activity in activities) {
        rollbackError = (await DatabaseHandler().deleteActivity(activity)).error;
      }

      _globalError.add(rollbackError ?? error);
    } else {
      Navigator.pushNamed(context, routes.home.name);
      _resetActivity();
    }
  }
}
