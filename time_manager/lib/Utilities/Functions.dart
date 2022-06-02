import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Utilities/objects.dart';

String dateTimeToTimeString(DateTime dateTime) => dateTime.hour.toString().padLeft(2, '0') + ":" + dateTime.minute.toString().padLeft(2, '0');

String timeOfDayToTimeString(TimeOfDay timeOfDay) => timeOfDay.hour.toString().padLeft(2, '0') + ":" + timeOfDay.minute.toString().padLeft(2, '0');

T notNullOrFail<T>(T? object) {
  if (object == null) NullThrownError();
  return object as T;
}

///Crops [activity] in relation to [activities] and returns list of cropped activities
List<Activity> cropSingleActivity(List<Activity> activities, activity) {
  //SORT OBJECTS BY DATETIME

  List<Activity> croppedList = [activity];

  for (Activity existingActivity in activities) {
    List<Activity> tempList = [];

    croppedList.forEach((element) => tempList.addAll(_cropActivity(element, existingActivity)));

    croppedList = tempList;

  }

  return croppedList..sort((a, b) => a.starttime.compareTo(b.starttime));
}

///Crops activities in [activities] in relation to [activity] and returns list of cropped activities
List<Activity> cropListOfActivities(List<Activity> activities, Activity activity) {
  List<Activity> croppedList = [];

  activities.forEach((existingActivity) => croppedList.addAll(_cropActivity(existingActivity, activity)));
  
  return croppedList..sort((a, b) => a.starttime.compareTo(b.starttime));
}

///Crops [toCrop] in relation to [notToCrop] and returns list of cropped activities
List<Activity> _cropActivity(Activity toCrop, Activity notToCrop) {
  //toCrop is inside notToCrop and is removed completely
  if ((toCrop.starttime.isAfter(notToCrop.starttime) || toCrop.starttime.isAtSameMomentAs(notToCrop.starttime)) &&
      (toCrop.endtime.isBefore(notToCrop.endtime) || toCrop.endtime.isAtSameMomentAs(notToCrop.endtime))) return [];

  //notToCrop is inside toCrop, an toCrop is split in two
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

List<Activity> getIntersectingActivities(List<Activity> activities, activity) {
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

List<Activity> getActivitiesOfDay(List<Activity> activities, DateTime date) {
  List<Activity> activitesOfDay = activities.where((activity) {
    DateTime cleanDate1 = DateTime(activity.starttime.year, activity.starttime.month, activity.starttime.day);
    DateTime cleanDate2 = DateTime(date.year, date.month, date.day);
    return cleanDate1.isAtSameMomentAs(cleanDate2);
  }).toList();

  sortActivitiesByDateTime(activitesOfDay);

  return activitesOfDay;
}

List<Pair<Activity, Color?>> getActivitiesWithColors(List<Activity> activities, List<Category> categories) {
  Map<String, Color> categoryMap = Map.fromEntries(categories.map((category) => MapEntry(category.name, category.color)));
  return activities.map((activity) => Pair(first: activity, last: categoryMap[activity.category])).toList();
}

List<Pair<Activity, Color?>> getDiagramData(List<Activity> activities, DateTime date, List<Category> categories) {
  activities = getActivitiesOfDay(activities, date);

  Activity defaultActivity = Activity(starttime: DateTime(date.year, date.month, date.day, 0, 0), endtime: DateTime(date.year, date.month, date.day, 23, 59), category: 'default');

  List<Activity> defact = cropSingleActivity(activities, defaultActivity);

  activities = activities..addAll(cropSingleActivity(activities, defaultActivity));

  sortActivitiesByDateTime(activities);

  return getActivitiesWithColors(activities, categories);
}

void sortActivitiesByDateTime(List<Activity> activities) {
  activities.sort((a, b) => a.starttime.compareTo(b.starttime));
}
