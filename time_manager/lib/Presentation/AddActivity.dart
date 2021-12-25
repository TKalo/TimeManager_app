import 'package:flutter/material.dart';
import 'package:time_manager/Processing/AddActivityViewModel.dart';
import 'package:time_range_picker/time_range_picker.dart';
import 'package:time_manager/Processing/MainViewModel.dart';

class AddActivity extends StatelessWidget {
  AddActivity({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController timeContoller = TextEditingController();
  final AddActivityViewModel viewModel = AddActivityViewModel();
  final types = ['fun', 'nothing', 'necessary', 'productive'];

  @override
  Widget build(BuildContext context) {
    TextEditingController timeContoller = TextEditingController();

    AddActivityViewModel viewModel = AddActivityViewModel();

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
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      onChanged: (item) => viewModel.activity.category = item ?? '',
                      items: types.map((e) => DropdownMenuItem(child: Text(e),value: e,)).toList(),
                      decoration: const InputDecoration(labelText: 'Activity Category *', border: OutlineInputBorder()),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, routes.categoryList.name),
                    icon: const Icon(Icons.edit)
                  )
                ],
              ),

              TextFormField(
                decoration: const InputDecoration(labelText: 'Activity Name', border: OutlineInputBorder()),
                maxLength: 30,
                onChanged: (string) => viewModel.activity.name = string,
              ),

              TextFormField(
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(labelText: 'Activity Description', border: OutlineInputBorder()),
                maxLines: 10,
                onChanged: (string) => viewModel.activity.description = string,
              ),

              TextFormField(
                  controller: timeContoller,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(labelText: 'Activity time', border: OutlineInputBorder()),
                  readOnly: true,
                  onTap: () => onTimeFormFieldTap(context)),

              TextButton(
                  onPressed: () => onSubmitButtonPress(context),
                  child: Container(width: double.infinity, alignment: Alignment.center, height: 48, child: const Text('submit', style: TextStyle(fontSize: 18))))
              //time
            ],
          ),
        ),
      ]),
    );
  }

  void onTimeFormFieldTap(BuildContext context) async {
    TimeRange interval = await showTimeRangePicker(
      context: context,
      interval: const Duration(minutes: 5),
      disabledTime: TimeRange(startTime: const TimeOfDay(hour: 0, minute: 0), endTime: const TimeOfDay(hour: 0, minute: 0))

    );

    viewModel.setInterval(interval.startTime, interval.endTime);
    timeContoller.text = interval.startTime.format(context) + " - " + interval.endTime.format(context);
  }

  void onSubmitButtonPress(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      viewModel.submitActivity(context);
    }
  }
}
