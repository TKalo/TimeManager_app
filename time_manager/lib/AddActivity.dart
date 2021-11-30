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
    TextEditingController timeContoller = TextEditingController();

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
                  onTap: () async {
                    Future<TimeOfDay?> startTime = showTimePicker(
                        context: context, initialTime: TimeOfDay.now());

                    startTime.then((starttime) {
                      if (starttime != null) {
                        Future<TimeOfDay?> endTime = showTimePicker(
                            context: context, initialTime: starttime);

                        endTime.then((endtime) {
                          if (endtime != null) {
                            timeContoller.text = (starttime.format(context) +
                                " - " +
                                endtime.format(context));

                            DateTime now = DateTime.now();
                            selectedDateTime = DateTime(now.year, now.month,
                                now.day, starttime.hour, starttime.minute);
                            selectedDuration = selectedDateTime?.difference(
                                DateTime(now.year, now.month, now.day,
                                    endtime.hour, endtime.minute));
                          }
                        });
                      }
                    });
                  }),

              TextButton(
                  onPressed: () async {
                    if ((_formKey.currentState?.validate() ?? false) &&
                        selectedDateTime != null &&
                        selectedDuration != null &&
                        selectedCategory != null) {
                      Database().addToDatabase(ActivityObject(
                          datetime: selectedDateTime ?? DateTime(0, 0, 0, 0),
                          duration: selectedDuration ?? const Duration(),
                          category: selectedCategory ?? '',
                          name: selectedName,
                          description: selectedDescription));
                      setCurrentView(routes.home);

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
