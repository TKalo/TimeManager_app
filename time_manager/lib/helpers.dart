import 'package:time_manager/persistence/Objects/ActivityObject.dart';

String getTimeString(DateTime dateTime) =>
    dateTime.hour.toString().padLeft(2,'0') + ":" + dateTime.minute.toString().padLeft(2,'0');

List<ActivityObject> getSelectedDateActivities(List<ActivityObject> existingActivities, DateTime selectedDate) {
    return existingActivities.where((existingActivity) {
      DateTime cleanDate1 = DateTime(existingActivity.starttime.year, existingActivity.starttime.month, existingActivity.starttime.day);
      DateTime cleanDate2 = DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      return cleanDate1.isAtSameMomentAs(cleanDate2);
    }).toList();
  }
  
T notNullOrFail<T>(T? object) {
  if (object == null) NullThrownError();
  return object as T;
}