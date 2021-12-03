import 'package:flutter/material.dart';
import 'package:time_manager/ActivityObject.dart';
import 'package:time_manager/Routing.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'database.dart';
import 'helpers.dart';

class AddActivity extends StatelessWidget {
  AddActivity({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final types = ['fun', 'nothing', 'necessary', 'productive'];

  @override
  Widget build(BuildContext context) {
    TextEditingController timeContoller = TextEditingController();

    ActivityObject activity = ActivityObject(
        datetime: DateTime.now(),
        duration: const Duration(seconds: 0),
        category: '');

    return Material(
      child: ListView(padding: const EdgeInsets.all(48), children: [
        Form(
          key: _formKey,
          child: Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            runSpacing: 32,
            direction: Axis.horizontal,
            children: [
              DropdownButtonFormField<String>(
                onChanged: (item) => activity.category = item ?? '',
                items: types
                    .map((e) => DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        ))
                    .toList(),
                decoration: const InputDecoration(
                    labelText: 'Activity Category *',
                    border: OutlineInputBorder()),
              ),

              TextFormField(
                decoration: const InputDecoration(
                    labelText: 'Activity Name', border: OutlineInputBorder()),
                maxLength: 30,
                onChanged: (string) => activity.name = string,
              ),

              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    labelText: 'Activity Description',
                    border: OutlineInputBorder()),
                maxLines: 10,
                onChanged: (string) => activity.description = string,
              ),

              TextFormField(
                controller: timeContoller,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    labelText: 'Activity time', border: OutlineInputBorder()),
                readOnly: true,
                onTap: () {
                  pickTimeRange((datetime, duration) {
                    activity.datetime = datetime;
                    activity.duration = duration;
                    timeContoller.text = (datetime.toString() +
                        " - " +
                        datetime.add(duration).toString());
                  }, context);
                },
              ),

              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      onSubmit(activity, context);
                    }
                  },
                  child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      height: 48,
                      child:
                          const Text('submit', style: TextStyle(fontSize: 18))))
              //time
            ],
          ),
        ),
      ]),
    );
  }
}

pickTimeRange(Function(DateTime datetime, Duration duration) onTimeSelected,
    BuildContext context) async {
  TimeRange interval = await showTimeRangePicker(
    context: context,
    interval: const Duration(minutes: 5),
  );

  int offset = await shared_data().getDayOffsetStream().first;
  DateTime selectedDate = DateTime.now().add(Duration(days: offset));

  DateTime selectedStartDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      interval.startTime.hour,
      interval.startTime.minute);

  DateTime selectedEndDateTime = DateTime(selectedDate.year, selectedDate.month,
      selectedDate.day, interval.endTime.hour, interval.endTime.minute);

  onTimeSelected(selectedStartDateTime,
      -selectedStartDateTime.difference(selectedEndDateTime));
}

void onSubmit(ActivityObject activity, BuildContext context) async {
  //TODO: check that no other activities are logged for this time period

  List<ActivityObject> data = await shared_data().getStream().first;
  List<ActivityObject> selectedData = data
      .where((object) =>
          checkDateTimesOnSameDay(object.datetime, activity.datetime))
      .toList();
  List<ActivityObject> intersectingActivities =
      getActivitiesInSameTimeInterval(selectedData, activity);

  //If any are at the same time, ask if user will crop them, this, or cancel
  if (intersectingActivities.isNotEmpty) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
                'other activities intersect the selected time interval'),
            actions: [
              TextButton(onPressed: () => cropThisActivity(intersectingActivities, activity), child: Text('crop this activity')),
              TextButton(
                  onPressed: () {}, child: Text('crop other activities')),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('cancel'))
            ],
          );
        });
  } else {
    shared_data().addActivity(activity);
    Navigator.pushNamed(context, routes.home.name);
  }

  activity = ActivityObject(
      datetime: DateTime.now(),
      duration: const Duration(seconds: 0),
      category: '');
}

cropOtherActivities(
    List<ActivityObject> existingActivities, ActivityObject newActivity) {
  DateTime newStartDT = newActivity.datetime;
  DateTime newEndDT = newStartDT.add(newActivity.duration);

  existingActivities.forEach((existingActivity) {
    DateTime existingStartDT = newActivity.datetime;
    DateTime existingEndDT = newStartDT.add(newActivity.duration);

    if (existingStartDT.isBefore(newStartDT) &&
        existingEndDT.isAfter(newEndDT)) {
      //DELETE ACTIVITY
    } else if (existingStartDT.isBefore(newStartDT)) {
      //CHANGE DURATION
    } else if (existingEndDT.isAfter(newEndDT)) {
      //CHANGE DATETIME
    }
  });
}

cropThisActivity(
    List<ActivityObject> existingActivities, ActivityObject newActivity) {
  //SORT OBJECTS BY DATETIME
  existingActivities.sort((o1, o2) => o1.datetime.compareTo(o2.datetime));

  List<ActivityObject> croppedActivities = [];

  for (int x = 0; x < existingActivities.length-1; x++) {
    if (x == 0) {
      if (existingActivities[x].datetime.isAfter(newActivity.datetime)) {
        croppedActivities.add(ActivityObject(
            datetime: newActivity.datetime,
            duration: -newActivity.datetime
                .difference(existingActivities[x].datetime),
            category: newActivity.category,
            name: newActivity.name,
            description: newActivity.description));
      }
      } else if (existingActivities[x].datetime.isAfter(
          existingActivities[x - 1]
              .datetime
              .add(existingActivities[x - 1].duration))) {
        DateTime endtime = existingActivities[x - 1]
            .datetime
            .add(existingActivities[x - 1].duration);

        croppedActivities.add(ActivityObject(
            datetime: endtime,
            duration: endtime.difference(existingActivities[x].datetime),
            category: newActivity.category,
            name: newActivity.name,
            description: newActivity.description));
    }
  }
  
  croppedActivities.forEach((activity) => shared_data().addActivity(activity));
}

List<ActivityObject> getActivitiesInSameTimeInterval(
    List<ActivityObject> existingActivities, ActivityObject newActivity) {
  return existingActivities.where((existingActivity) {
    DateTime newEndDT = newActivity.datetime.add(newActivity.duration);

    DateTime existingStartDT = existingActivity.datetime;
    DateTime existingEndDT = existingStartDT.add(existingActivity.duration);

    return existingStartDT.isBefore(newEndDT) &&
            existingStartDT.isAfter(newActivity.datetime) ||
        existingEndDT.isBefore(newEndDT) &&
            existingEndDT.isAfter(newActivity.datetime);
  }).toList();
}
