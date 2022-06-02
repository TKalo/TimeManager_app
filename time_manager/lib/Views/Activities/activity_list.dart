import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:time_manager/Controllers/main_viewmodel.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Utilities/functions.dart';
import 'package:time_manager/Utilities/objects.dart';
import 'package:time_manager/Views/Activities/activity_list_item.dart';

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
