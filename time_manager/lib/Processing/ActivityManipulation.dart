import 'package:time_manager/persistence/Objects/ActivityObject.dart';

class ActivityManipulation {
  ///Crops [activity] in relation to [activities] and returns list of cropped activities
  static List<ActivityObject> cropSingleActivity(List<ActivityObject> activities, activity) {
    //SORT OBJECTS BY DATETIME

    List<ActivityObject> croppedList = [activity];

    for (ActivityObject existingActivity in activities) {
      List<ActivityObject> tempList = [];
      
      croppedList.forEach((element) => tempList.addAll(_cropActivity(activity, existingActivity)));
    
      croppedList = tempList;
    }

    return croppedList..sort((a, b) => a.starttime.compareTo(b.starttime));
  }

  ///Crops activities in [activities] in relation to [activity] and returns list of cropped activities
  static List<ActivityObject> cropOtherActivities(List<ActivityObject> activities, ActivityObject activity) {
    List<ActivityObject> croppedList = [];

    activities.forEach((existingActivity) => croppedList.addAll(_cropActivity(existingActivity, activity)));

    return croppedList..sort((a, b) => a.starttime.compareTo(b.starttime));
  }

  ///Crops [toCrop] in relation to [notToCrop] and returns list of cropped activities
  static List<ActivityObject> _cropActivity(ActivityObject toCrop, ActivityObject notToCrop) {
    //toCrop is inside notToCrop and is removed completely
    if ((toCrop.starttime.isAfter(notToCrop.starttime) || toCrop.starttime.isAtSameMomentAs(notToCrop.starttime)) &&
        (toCrop.endtime.isBefore(notToCrop.endtime) || toCrop.endtime.isAtSameMomentAs(notToCrop.endtime))) return [];

    //to notToCrop is inside toCrop, an toCrop is split in two
    if (toCrop.starttime.isBefore(notToCrop.starttime) && toCrop.endtime.isAfter(notToCrop.endtime)) {
      return [toCrop.copy()..endtime = notToCrop.starttime, toCrop.copy()..starttime = notToCrop.endtime];
    }

    //to crop starttime is inside notToCrop: toCrop starttime is cropped to notToCrop endtime
    if ((toCrop.starttime.isAfter(notToCrop.starttime) || toCrop.starttime.isAtSameMomentAs(notToCrop.starttime)) && toCrop.starttime.isBefore(notToCrop.endtime))
      return [toCrop.copy()..starttime = notToCrop.endtime];

    //to crop endtime is inside notToCrop: toCrop endtime is cropped to notToCrop starttime
    if ((toCrop.endtime.isBefore(notToCrop.endtime) || toCrop.endtime.isAtSameMomentAs(notToCrop.endtime)) && toCrop.endtime.isAfter(notToCrop.starttime))
      return [toCrop.copy()..endtime = notToCrop.starttime];

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
