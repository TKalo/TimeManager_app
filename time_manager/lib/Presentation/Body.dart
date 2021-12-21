import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/Processing/MainViewModel.dart';
import 'package:time_manager/helpers.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';


class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Head(),
        Expanded(
          child: ActivityList(),
        )
      ],
    );
  }
}

class Head extends StatelessWidget {
  Head({Key? key}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();

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
              onPressed: () async => mainViewModel.decreaseFocusDay(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            Expanded(child: Diagram()),
            IconButton(
              onPressed: () async => mainViewModel.increaseFocusDay(),
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
  Diagram({Key? key}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ActivityObject>>(
      stream: mainViewModel.getActivities(),
      builder: (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> data = snapshot.data ?? [];
        data.sort((a, b) => a.starttime.compareTo(b.starttime));

        return StreamBuilder<DateTime>(
            stream: mainViewModel.getFocusDay(),
            builder: (context, snapshot) {
              DateTime selectedDate = snapshot.data ?? DateTime.now();
              List<ActivityObject> selectedData = getSelectedDateActivities(data, selectedDate);

              return SfCircularChart(
                series: <DoughnutSeries<ActivityObject, String>>[
                  DoughnutSeries(
                      dataSource: selectedData,
                      xValueMapper: (ActivityObject object, int index) => object.category,
                      yValueMapper: (ActivityObject object, int index) => -object.starttime.difference(object.endtime).inMinutes)
                ],
              );
            });
      },
    );
  }
}

class ActivityList extends StatelessWidget {
  ActivityList({Key? key}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ActivityObject>>(
      stream: mainViewModel.getActivities(),
      builder: (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> data = snapshot.data ?? [];

        return StreamBuilder<DateTime>(
          stream: mainViewModel.getFocusDay(),
          builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
            DateTime selectedDate = snapshot.data ?? DateTime.now();
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
  ActivityListItem({Key? key, required this.activity}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();
  final ActivityObject activity;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<ActivityObject>(activity),
      onDismissed: (DismissDirection direction) {
        mainViewModel.deleteActivity(activity);
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
