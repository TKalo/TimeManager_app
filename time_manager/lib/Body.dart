import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/database.dart';
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
        decoration: const BoxDecoration(color: Colors.blue, boxShadow: [
          BoxShadow(
              color: Color(0xffd9d9d9),
              spreadRadius: 0,
              blurRadius: 8,
              offset: Offset(0, 7))
        ]),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => shared_data().reduceDayOffset(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),

            const Expanded(
              child: Diagram()
            ),

            IconButton(
              onPressed: () => shared_data().increaseDayOffset(),
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
      stream: shared_data().getStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> data = snapshot.data ?? [];
        data.sort((a, b) => a.datetime.compareTo(b.datetime));

        return StreamBuilder<int>(
            stream: shared_data().getDayOffsetStream(),
            builder: (context, snapshot) {
              int offset = snapshot.data ?? 0;
              DateTime selectedDate =
                  DateTime.now().add(Duration(days: offset));
              List<ActivityObject> selectedData = data
                  .where((object) =>
                      checkDateTimesOnSameDay(object.datetime, selectedDate))
                  .toList();

              return SfCircularChart(
                series: <DoughnutSeries<ActivityObject, String>>[
                  DoughnutSeries(
                      dataSource: selectedData,
                      xValueMapper: (ActivityObject object, int index) => object.category,
                      yValueMapper: (ActivityObject object, int index) => object.duration.inMinutes)
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
      stream: shared_data().getStream(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        List<ActivityObject> data = snapshot.data ?? [];

        return StreamBuilder<int>(
          stream: shared_data().getDayOffsetStream(),
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            int offset = snapshot.data ?? 0;
            DateTime selectedDate = DateTime.now().add(Duration(days: offset));
            List<ActivityObject> selectedData = data
                .where((object) =>
                    checkDateTimesOnSameDay(object.datetime, selectedDate))
                .toList();

            print(offset);
            print(selectedDate.day);

            return ListView.builder(
              itemBuilder: (c, i) => ActivityListItem(object: selectedData[i]),
              itemCount: selectedData.length,
            );
          },
        );
      },
    );
  }
}

class ActivityListItem extends StatelessWidget {
  final ActivityObject object;

  const ActivityListItem({Key? key, required this.object}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<ActivityObject>(object),
      onDismissed: (DismissDirection direction) {
        shared_data().removeActivity(object);
      },
      confirmDismiss: (DismissDirection direction) {
        return showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Delete activity?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('delete')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('cancel')),
                  ],
                ));
      },
      child: Card(
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: Container(
            height: 64,
            width: 64,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
          ),
          title: Text(object.name ?? object.category),
          subtitle: Text(getTimeString(object.datetime) +
              " - " +
              getTimeString(object.datetime.add(object.duration))),
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
