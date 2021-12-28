
String getTimeString(DateTime dateTime) => dateTime.hour.toString().padLeft(2, '0') + ":" + dateTime.minute.toString().padLeft(2, '0');

T notNullOrFail<T>(T? object) {
  if (object == null) NullThrownError();
  return object as T;
}
