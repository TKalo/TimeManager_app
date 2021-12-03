import 'package:flutter/material.dart';
import 'package:time_manager/Routing.dart';
import 'ActivityObject.dart';
import 'Model.dart';
import 'helpers.dart';

class AddActivityViewModel {
  static final AddActivityViewModel _singleton = AddActivityViewModel._internal();
  factory AddActivityViewModel() => _singleton;
  AddActivityViewModel._internal();

  ActivityObject activity = ActivityObject(starttime: DateTime.now(), endtime: DateTime.now(), category: '');

  void setInterval(TimeOfDay starttime, TimeOfDay endtime) async {
    int offset = await Model().getDayOffsetStream().first;
    DateTime selectedDate = DateTime.now().add(Duration(days: offset));

    activity.starttime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, starttime.hour, starttime.minute);

    activity.endtime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, endtime.hour, endtime.minute);

    print('time set: ' +
        starttime.hour.toString().padLeft(2, '0') +
        ":" +
        starttime.minute.toString().padLeft(2, '0') +
        " - " +
        endtime.hour.toString().padLeft(2, '0') +
        ":" +
        endtime.minute.toString().padLeft(2, '0'));
  }

  void submitActivity(BuildContext context) async {
    List<ActivityObject> allActivities = await Model().getStream().first;

    print(allActivities.map((e) => e.starttime.toString()));

    List<ActivityObject> selectedDateActivities = getSelectedDateActivities(allActivities, activity.starttime);
    List<ActivityObject> intersectingActivities = getIntersectingActivities(selectedDateActivities);

    print('intersectingActivities:' + intersectingActivities.length.toString());
    if (intersectingActivities.isNotEmpty) {
      requestIntersectingActivitiesResolution(context, intersectingActivities);
    } else {
      Model().addActivity(activity);
      resetActivityObject();
      Navigator.pushNamed(context, routes.home.name);
    }
  }

  void requestIntersectingActivitiesResolution(BuildContext context, List<ActivityObject> intersectingActivities) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('other activities intersect the selected time interval'),
            actions: [
              TextButton(
                  onPressed: () {
                    cropThisActivity(intersectingActivities);
                    Navigator.pushNamed(context, routes.home.name);
                    resetActivityObject();
                  },
                  child: const Text('crop this activity')),
              TextButton(
                  onPressed: () {
                    cropOtherActivities(intersectingActivities);
                    Navigator.pushNamed(context, routes.home.name);
                    resetActivityObject();
                  },
                  child: const Text('crop other activities')),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('cancel'))
            ],
          );
        });
  }

  cropOtherActivities(List<ActivityObject> existingActivities) {
    for (ActivityObject existingActivity in existingActivities) {
      if (existingActivity.starttime.isBefore(activity.starttime) && existingActivity.endtime.isAfter(activity.endtime)) {
        //DELETE ACTIVITY
      } else if (existingActivity.starttime.isBefore(activity.starttime)) {
        //CHANGE DURATION
      } else if (existingActivity.endtime.isAfter(activity.endtime)) {
        //CHANGE DATETIME
      }
    }
  }

  cropThisActivity(List<ActivityObject> existingActivities) {
    //SORT OBJECTS BY DATETIME
    existingActivities.sort((o1, o2) => o1.starttime.compareTo(o2.starttime));

    List<ActivityObject> croppedActivities = [];

    for (int x = 0; x < existingActivities.length - 1; x++) {
      //Special case for first object
      if (x == 0) {
        //If new activity starts before first intersecting activity, create cropped activity
        if (existingActivities[x].starttime.isAfter(activity.starttime)) {
          croppedActivities
              .add(ActivityObject(starttime: activity.starttime, endtime: existingActivities[x].starttime, category: activity.category, name: activity.name, description: activity.description));
        }

        //Special case for last object
      } else if (x == existingActivities.length - 1) {
        //If new activity ends after last intersecting activity, create cropped activity
        if (existingActivities[x].endtime.isBefore(activity.endtime)) {
          croppedActivities
              .add(ActivityObject(starttime: existingActivities[x].endtime, endtime: activity.endtime, category: activity.category, name: activity.name, description: activity.description));
        }

        //if two intersecting activities have a gap inbetween, create cropped activity
      } else if (existingActivities[x].starttime.isAfter(existingActivities[x - 1].endtime)) {
        croppedActivities.add(ActivityObject(
            starttime: existingActivities[x - 1].endtime, endtime: existingActivities[x].starttime, category: activity.category, name: activity.name, description: activity.description));
      }
    }

    print('croppedActivities: ' + croppedActivities.length.toString());

    for (ActivityObject croppedActivity in croppedActivities) {
      Model().addActivity(croppedActivity);
    }
  }

  List<ActivityObject> getIntersectingActivities(List<ActivityObject> activities) {
    print('CurrentDateActivities:' + activities.length.toString());

    return activities.where((existingActivity) {
      print('activity.starttime: ' + activity.starttime.toString());
      print('activity.endtime: ' + activity.endtime.toString());
      print('existingActivity.starttime: ' + existingActivity.starttime.toString());
      print('existingActivity.endtime: ' + existingActivity.endtime.toString());
      print('\n');

      //Check if existing activity starttime intersect with new activity time interval
      if ((existingActivity.starttime.isAfter(activity.starttime) || existingActivity.starttime.isAtSameMomentAs(activity.starttime)) && existingActivity.starttime.isBefore(activity.endtime))
        return true;

      //Check if existing activity endtime intersect with new activity time interval
      if (existingActivity.endtime.isAfter(activity.starttime) && (existingActivity.endtime.isBefore(activity.endtime) || existingActivity.endtime.isAtSameMomentAs(activity.endtime))) return true;

      //Check if new activity is within existing activity
      if (existingActivity.starttime.isBefore(activity.starttime) && existingActivity.endtime.isAfter(activity.endtime)) return true;

      return false;
    }).toList();
  }

  void resetActivityObject() {
    activity = ActivityObject(starttime: DateTime.now(), endtime: DateTime.now(), category: '');
  }
}
