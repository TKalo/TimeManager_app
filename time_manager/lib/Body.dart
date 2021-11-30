import 'package:flutter/material.dart';
import 'package:time_manager/database.dart';
import 'ActivityObject.dart';
import 'Navbar.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Diagram(),
        Expanded(
          child: ActivityList(),
        )
      ],
    );
  }
}

class Diagram extends StatelessWidget {
  const Diagram({Key? key}) : super(key: key);

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

String getTimeString(DateTime dateTime) =>
    dateTime.hour.toString() + ":" + dateTime.minute.toString();

bool checkDateTimesOnSameDay(DateTime date1, DateTime date2) {
  DateTime cleanDate1 = DateTime(date1.year, date1.month, date1.day);
  DateTime cleanDate2 = DateTime(date2.year, date2.month, date2.day);
  return cleanDate1.isAtSameMomentAs(cleanDate2);
}
