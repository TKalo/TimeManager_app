import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/Model.dart';
import 'ActivityObject.dart';
import 'helpers.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Head(),
        Expanded(
          child: ActivityList(),
        )
      ],
    );
  }
}

class Head extends StatelessWidget {
  const Head({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 260,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(color: Colors.blue, boxShadow: [BoxShadow(color: Color(0xffd9d9d9), spreadRadius: 0, blurRadius: 8, offset: Offset(0, 7))]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Model().reduceDayOffset(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Expanded(child: Diagram()),
            IconButton(
              onPressed: () => Model().increaseDayOffset(),
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
      onHorizontalDragEnd: (DragEndDetails details) {},
      onHorizontalDragStart: (DragStartDetails details) {},
    );
  }
}

class Diagram extends StatelessWidget {
  const Diagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ActivityObject>>(
      stream: Model().getStream(),
      builder: (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> data = snapshot.data ?? [];
        data.sort((a, b) => a.starttime.compareTo(b.starttime));

        return StreamBuilder<int>(
            stream: Model().getDayOffsetStream(),
            builder: (context, snapshot) {
              int offset = snapshot.data ?? 0;
              DateTime selectedDate = DateTime.now().add(Duration(days: offset));
              List<ActivityObject> selectedData = getSelectedDateActivities(data, selectedDate);

              return SfCircularChart(
                series: <DoughnutSeries<ActivityObject, String>>[
                  DoughnutSeries(
                      dataSource: selectedData, xValueMapper: (ActivityObject object, int index) => object.category, yValueMapper: (ActivityObject object, int index) => -object.starttime.difference(object.endtime).inMinutes)
                ],
              );
            });
      },
    );
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ActivityObject>>(
      stream: Model().getStream(),
      builder: (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> data = snapshot.data ?? [];

        return StreamBuilder<int>(
          stream: Model().getDayOffsetStream(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            int offset = snapshot.data ?? 0;
            DateTime selectedDate = DateTime.now().add(Duration(days: offset));
            List<ActivityObject> selectedData = getSelectedDateActivities(data, selectedDate);

            return ListView.builder(
              itemBuilder: (c, i) => ActivityListItem(activity: selectedData[i]),
              itemCount: selectedData.length,
            );
          },
        );
      },
    );
  }
}

class ActivityListItem extends StatelessWidget {
  final ActivityObject activity;

  const ActivityListItem({Key? key, required this.activity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<ActivityObject>(activity),
      onDismissed: (DismissDirection direction) {
        Model().removeActivity(activity);
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
          title: Text(activity.name ?? activity.category),
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
