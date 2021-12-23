import 'package:flutter/material.dart';
import 'package:time_manager/Processing/MainViewModel.dart';
import 'package:time_manager/persistence/DatabaseHandler.dart';
import 'package:time_manager/persistence/Interfaces/IFrontendDatabase.dart';
import '../persistence/Objects/ActivityObject.dart';
import '../helpers.dart';
import 'ActivityManipulation.dart';

class AddActivityViewModel {
  static final AddActivityViewModel _singleton = AddActivityViewModel._internal();
  factory AddActivityViewModel() => _singleton;
  AddActivityViewModel._internal();

  ActivityObject activity = ActivityObject(starttime: DateTime.now(), endtime: DateTime.now(), category: '');

  MainViewModel mainViewModel = MainViewModel();

  IFrontendDatabase storage = DatabaseHandler();


  void setInterval(TimeOfDay starttime, TimeOfDay endtime) async {
    DateTime selectedDate = await mainViewModel.getFocusDay().first;

    activity.starttime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, starttime.hour, starttime.minute);

    activity.endtime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, endtime.hour, endtime.minute);
  }

  
  void submitActivity(BuildContext context) async {
    
    List<ActivityObject> allActivities = await storage.getActivities().first;

    List<ActivityObject> selectedDateActivities = getSelectedDateActivities(allActivities, activity.starttime);
   
    List<ActivityObject> intersectingActivities = ActivityManipulation.getIntersectingActivities(selectedDateActivities, activity);

    if (intersectingActivities.isNotEmpty) {

      _requestIntersectingActivitiesResolution(context, intersectingActivities);

    } else {

      storage.addActivity(activity);

      _resetActivityObject();

      Navigator.pushNamed(context, routes.home.name);

    }

  }


  void _requestIntersectingActivitiesResolution(BuildContext context, List<ActivityObject> intersectingActivities) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('other activities intersect the selected time interval'),
          actions: [
            TextButton(
                onPressed: () {
                  ActivityManipulation.cropSingleActivity(intersectingActivities, activity);
                  Navigator.pushNamed(context, routes.home.name);
                  _resetActivityObject();
                },
                child: const Text('crop this activity')),
            TextButton(
                onPressed: () {
                  ActivityManipulation.cropOtherActivities(intersectingActivities, activity);
                  Navigator.pushNamed(context, routes.home.name);
                  _resetActivityObject();
                },
                child: const Text('crop other activities')),
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('cancel'))
          ],
        );
      }
    );
  }

  void _resetActivityObject() {

    activity = ActivityObject(starttime: DateTime.now(), endtime: DateTime.now(), category: '');

  }
}
