import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Logic/MainViewModel.dart';
import 'package:time_manager/Utilities/ActivityManipulation.dart';
import 'package:time_manager/Utilities/ReusableWidgets.dart';
import 'package:time_manager/Utilities/helpers.dart';

class ActivityList extends StatelessWidget {
  ActivityList({Key? key}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();

  @override
  Widget build(BuildContext context) {
    Stream<List<ActivityObject>> stream = CombineLatestStream.combine2<List<ActivityObject>, DateTime, List<ActivityObject>>(
        MainViewModel().getActivities(), MainViewModel().getFocusDay(), (List<ActivityObject> activities, DateTime? date) => getActivitiesOfDay(activities, date ?? DateTime.now()));

    return StreamBuilder<List<ActivityObject>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> activities = snapshot.data ?? [];

        return ListView.builder(
          itemBuilder: (c, i) => ActivityListItem(activity: activities[i]),
          itemCount: activities.length,
        );
      },
    );
  }
}

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({Key? key, required this.activity}) : super(key: key);

  final ActivityObject activity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<ActivityObject>(activity),
      onDismissed: (DismissDirection direction) => MainViewModel().deleteActivity(activity),
      confirmDismiss: (DismissDirection direction) => confirmDismiss(context),
      child: CustomListTile(
        leadingColor: Colors.red, 
        title: activity.name == '' ? activity.category : activity.name,
        subTitle: getTimeString(activity.starttime) + " - " + getTimeString(activity.endtime)
      ),
      background: const ListDeleteBackground(),
    );
  }

  Future<bool?> confirmDismiss(BuildContext context) {
    return showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Delete activity?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('delete')),
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('cancel')),
                  ],
                ));
  }
}
