import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_manager/Database/DatabaseHandler.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Utilities/ActivityManipulation.dart';
import 'package:time_manager/Utilities/Pair.dart';

class MainViewModel {
  static final MainViewModel _singleton = MainViewModel._internal();
  factory MainViewModel() => _singleton;
  MainViewModel._internal();

  final BehaviorSubject<DateTime> _focusDay = BehaviorSubject.seeded(DateTime.now());
  Stream<DateTime> getFocusDay() => _focusDay.stream;
  void setFocusDay(DateTime dateTime) => _focusDay.add(dateTime);
  void increaseFocusDay() async => _focusDay.add((await _focusDay.first).add(const Duration(days: 1)));
  void decreaseFocusDay() async => _focusDay.add((await _focusDay.first).subtract(const Duration(days: 1)));

  Stream<List<ActivityObject>> getActivities() => DatabaseHandler().getActivities();
  Stream<List<CategoryObject>> getCategories() => DatabaseHandler().getCategories();
  void deleteActivity(ActivityObject activity) => DatabaseHandler().deleteActivity(activity);
  void deleteCategory(CategoryObject category) => DatabaseHandler().deleteCategory(category);

  List<Pair<ActivityObject, Color>> processData(List<ActivityObject> activities, DateTime date, List<CategoryObject> categories) {
    activities = getActivitiesOfDay(activities, date);

    ActivityObject defaultActivity = ActivityObject(starttime: DateTime(date.year, date.month, date.day, 0, 0), endtime: DateTime(date.year, date.month, date.day, 23, 59), category: 'default');

    activities = activities..addAll(cropSingleActivity(activities, defaultActivity));

    sortActivitiesByDateTime(activities);

    return activities.map((activity) => Pair(first: activity, last: categories.firstWhere((category) => category.name == activity.category, orElse: () => CategoryObject(name: '', color: Colors.grey)).color)).toList();
  }
}
