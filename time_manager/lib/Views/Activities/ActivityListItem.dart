import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Controllers/ActivityViewModel.dart';
import 'package:time_manager/Utilities/Functions.dart';
import 'package:time_manager/Utilities/Widgets.dart';

class ActivityListItem extends StatelessWidget {
  const ActivityListItem({Key? key, required this.activity, required this.color}) : super(key: key);

  final Activity activity;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(activity.id.toString()),
      onDismissed: (DismissDirection direction) => ActivityViewModel().deleteActivity(activity),
      confirmDismiss: (DismissDirection direction) => confirmDismiss(context),
      child: CustomListTile(leadingColor: color, title: activity.name == '' ? activity.category : activity.name, subTitle: dateTimeToTimeString(activity.starttime) + " - " + dateTimeToTimeString(activity.endtime)),
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
