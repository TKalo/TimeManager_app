String getTimeString(DateTime dateTime) =>
    dateTime.hour.toString() + ":" + dateTime.minute.toString();

bool checkDateTimesOnSameDay(DateTime date1, DateTime date2) {
  DateTime cleanDate1 = DateTime(date1.year, date1.month, date1.day);
  DateTime cleanDate2 = DateTime(date2.year, date2.month, date2.day);
  return cleanDate1.isAtSameMomentAs(cleanDate2);
}

