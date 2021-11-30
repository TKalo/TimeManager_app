import 'package:flutter/material.dart';
import 'package:time_manager/ActivityObject.dart';
import 'package:time_manager/Routing.dart';

import 'database.dart';

class AddActivity extends StatelessWidget {
  AddActivity({Key? key}) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final types = ['fun', 'nothing', 'necessary', 'productive'];

  String? selectedCategory;
  DateTime? selectedDateTime;
  Duration? selectedDuration;
  String? selectedName;
  String? selectedDescription;

  @override
  Widget build(BuildContext context) {
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

              TimePicker(
                  onTimeSelected: (DateTime datetime, Duration duration) {
                selectedDateTime = datetime;
                selectedDuration = duration;
              }),

              TextButton(
                  onPressed: () async {
                    if ((_formKey.currentState?.validate() ?? false) &&
                        selectedDateTime != null &&
                        selectedDuration != null &&
                        selectedCategory != null) {
                      shared_data().addActivity(ActivityObject(
                          datetime: selectedDateTime ?? DateTime(0, 0, 0, 0),
                          duration: selectedDuration ?? const Duration(),
                          category: selectedCategory ?? '',
                          name: selectedName,
                          description: selectedDescription));
                      Navigator.pushNamed(context, routes.home.name);

                      selectedDateTime = selectedDuration = selectedCategory =
                          selectedName = selectedDescription = null;
                    } else {
                      print(selectedDateTime.toString() +
                          "\n" +
                          selectedDuration.toString() +
                          "\n" +
                          selectedCategory.toString() +
                          "\n" +
                          selectedName.toString() +
                          "\n" +
                          selectedDescription.toString() +
                          "\n");
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

class TimePicker extends StatelessWidget {
  final Function(DateTime datetime, Duration duration) onTimeSelected;
  const TimePicker({Key? key, required this.onTimeSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController timeContoller = TextEditingController();

    return TextFormField(
        controller: timeContoller,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
            labelText: 'Activity time', border: OutlineInputBorder()),
        readOnly: true,
        onTap: () async {
          Future<TimeOfDay?> startTime =
              showTimePicker(context: context, initialTime: TimeOfDay.now());

          startTime.then((starttime) {
            if (starttime != null) {
              Future<TimeOfDay?> endTime =
                  showTimePicker(context: context, initialTime: starttime);

              endTime.then((endtime) async {
                if (endtime != null) {
                  timeContoller.text = (starttime.format(context) +
                      " - " +
                      endtime.format(context));
                  int offset = await shared_data().getDayOffsetStream().first;
                  DateTime selectedDate = offset > 0
                      ? DateTime.now().add(Duration(days: offset))
                      : DateTime.now().subtract(Duration(days: offset));

                  DateTime finalDate = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      starttime.hour,
                      starttime.minute);
                  Duration finalDuration = finalDate.difference(DateTime(
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
        });
  }
}
