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

    String? selectedCategory;
    DateTime? selectedDateTime;
    Duration? selectedDuration;
    String? selectedName;
    String? selectedDescription;

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
                onChanged: (item) => selectedCategory = item,
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
                onChanged: (string) => selectedName = string,
              ),

              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    labelText: 'Activity Description',
                    border: OutlineInputBorder()),
                maxLines: 10,
                onChanged: (string) => selectedDescription = string,
              ),
              TextFormField(
                controller: timeContoller,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    labelText: 'Activity time', border: OutlineInputBorder()),
                readOnly: true,
                onTap: () {
                  pickTimeRange((datetime, duration) {
                    selectedDateTime = datetime;
                    selectedDuration = duration;
                    timeContoller.text = (datetime.toString() +
                        " - " +
                        datetime.add(duration).toString());
                  }, context);
                },
              ),

              TextButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      onSubmit(
                          selectedCategory,
                          selectedDateTime,
                          selectedDuration,
                          selectedName,
                          selectedDescription,
                          context);
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

pickTime(Function(DateTime datetime, Duration duration) onTimeSelected,
    BuildContext context) async {
  Future<TimeOfDay?> startTime =
      showTimePicker(context: context, initialTime: TimeOfDay.now());

  startTime.then((starttime) {
    if (starttime != null) {
      Future<TimeOfDay?> endTime =
          showTimePicker(context: context, initialTime: starttime);

      endTime.then((endtime) async {
        if (endtime != null) {
          int offset = await shared_data().getDayOffsetStream().first;
          DateTime selectedDate = offset > 0
              ? DateTime.now().add(Duration(days: offset))
              : DateTime.now().subtract(Duration(days: offset));

          DateTime finalDate = DateTime(selectedDate.year, selectedDate.month,
              selectedDate.day, starttime.hour, starttime.minute);
          Duration finalDuration = -finalDate.difference(DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              endtime.hour,
              endtime.minute));

          onTimeSelected(finalDate, finalDuration);
        }
      });
    }
  });
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
      selectedStartDateTime.difference(selectedEndDateTime));
}

void onSubmit(
    String? selectedCategory,
    DateTime? selectedDateTime,
    Duration? selectedDuration,
    String? selectedName,
    String? selectedDescription,
    BuildContext context) async {
  //TODO: check that no other activities are logged for this time period

  List<ActivityObject> data = await shared_data().getStream().first;
  List<ActivityObject> selectedData = data
      .where((object) => checkDateTimesOnSameDay(
          object.datetime, selectedDateTime ?? DateTime.now()))
      .toList();

  //If any are at the same time, ask if user will crop them, this, or cancel
  if (checkAnyActivitiesInTimeInterval(selectedDateTime, selectedDuration, selectedData)) {
  } else {

  }

  shared_data().addActivity(ActivityObject(
      datetime: selectedDateTime ?? DateTime(0, 0, 0, 0),
      duration: selectedDuration ?? const Duration(),
      category: selectedCategory ?? '',
      name: selectedName,
      description: selectedDescription));
  Navigator.pushNamed(context, routes.home.name);

  selectedDateTime = selectedDuration =
      selectedCategory = selectedName = selectedDescription = null;
}



bool checkAnyActivitiesInTimeInterval(
    DateTime selectedStartDateTime,
    Duration selectedDuration,
    List<ActivityObject> activities) {
  return activities.any((element) {
    DateTime selectedEndDateTime = selectedStartDateTime.add(selectedDuration);

    DateTime elementStartDateTime = element.datetime;
    DateTime elementEndDateTime = elementStartDateTime.add(element.duration);

    return elementStartDateTime.isBefore(selectedEndDateTime) &&
        elementEndDateTime.isAfter(selectedStartDateTime);
  });
}
