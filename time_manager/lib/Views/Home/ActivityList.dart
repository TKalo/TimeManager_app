import 'package:flutter/material.dart';
import 'package:rxdart/streams.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Logic/MainViewModel.dart';
import 'package:time_manager/Utilities/ActivityManipulation.dart';
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
        print('activity list updated: ' + activities.toString());

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
      onDismissed: (DismissDirection direction) {
        MainViewModel().deleteActivity(activity);
      },
      confirmDismiss: (DismissDirection direction) {
        return showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Delete activity?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('delete')),
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('cancel')),
                  ],
                ));
      },
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Container(
            height: 64,
            width: 64,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
          title: Text(activity.name == '' ? activity.category : activity.name),
          subtitle: Text(getTimeString(activity.starttime) + " - " + getTimeString(activity.endtime)),
        ),
      ),
      background: Container(
        height: 80,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.all(32),
        child: const Icon(Icons.delete),
      ),
    );
  }
}
