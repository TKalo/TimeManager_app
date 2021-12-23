import 'package:time_manager/persistence/Objects/ActivityObject.dart';

class ActivityManipulation {
  ///Crops [activity] in relation to [activities] and returns list of cropped activities
  static List<ActivityObject> cropSingleActivity(List<ActivityObject> activities, activity) {
    //SORT OBJECTS BY DATETIME
    activities.sort((o1, o2) => o1.starttime.compareTo(o2.starttime));

    List<ActivityObject> croppedList = [activity];

    for (ActivityObject existingActivity in activities) {
      for (ActivityObject tempActivity in croppedList) {
        croppedList.remove(tempActivity);
        croppedList.addAll(cropActivity(existingActivity, activity));
      }
    }

    return croppedList;
  }

  ///Crops activities in [activities] in relation to [activity] and returns list of cropped activities
  static List<ActivityObject> cropOtherActivities(List<ActivityObject> activities, ActivityObject activity) {
    List<ActivityObject> newList = [activity];

    activities.forEach((existingActivity) => newList.addAll(cropActivity(existingActivity, activity)));

    return newList;
  }

  ///Crops [toCrop] in relation to [notToCrop] and returns list of cropped activities
  static List<ActivityObject> cropActivity(ActivityObject toCrop, ActivityObject notToCrop) {
    //toCrop is inside notToCrop and is removed completely
    if (toCrop.starttime.isAfter(notToCrop.starttime) && toCrop.endtime.isBefore(notToCrop.endtime)) return [];

    //to notToCrop is inside toCrop, an toCrop is split in two
    if (toCrop.starttime.isBefore(notToCrop.starttime) && toCrop.endtime.isAfter(notToCrop.endtime)) {
      return [toCrop.copy()..starttime = notToCrop.endtime, toCrop.copy()..endtime = notToCrop.starttime];
    }

    //to crop starttime is inside notToCrop: toCrop starttime is cropped to notToCrop endtime
    if (toCrop.starttime.isAfter(notToCrop.starttime) && toCrop.starttime.isBefore(notToCrop.endtime)) return [toCrop.copy()..starttime = notToCrop.endtime];

    //to crop endtime is inside notToCrop: toCrop endtime is cropped to notToCrop starttime
    if (toCrop.endtime.isBefore(notToCrop.endtime) && toCrop.endtime.isAfter(notToCrop.starttime)) return [toCrop.copy()..endtime = notToCrop.starttime];

    //There is no overlap and toCrop is returned
    return [toCrop];
  }

  static List<ActivityObject> getIntersectingActivities(List<ActivityObject> activities, activity) {
    return activities.where((existingActivity) {
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
}
