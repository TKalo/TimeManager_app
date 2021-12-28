import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Controllers/MainViewModel.dart';
import 'package:time_manager/Utilities/Functions.dart';
import 'package:time_manager/Utilities/Objects.dart';
import 'package:time_manager/Views/Activities/ActivityListItem.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<Pair<Activity, Color?>>> stream = CombineLatestStream.combine3<List<Activity>, DateTime, List<Category>, List<Pair<Activity, Color?>>>(
        MainViewModel().getActivities(),
        MainViewModel().getFocusDay(),
        MainViewModel().getCategories(),
        (List<Activity> activities, DateTime? date, List<Category> categories) => getActivitiesWithColors(getActivitiesOfDay(activities, date ?? DateTime.now()), categories));

    return StreamBuilder<List<Pair<Activity, Color?>>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<Pair<Activity, Color?>>> snapshot) {
        List<Pair<Activity, Color?>> activities = snapshot.data ?? [];

        return ListView.builder(
          itemBuilder: (c, i) => ActivityListItem(activity: activities[i].first, color: activities[i].last),
          itemCount: activities.length,
        );
      },
    );
  }
}
