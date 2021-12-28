class DatabaseResponseObject<T> {
  final bool success;
  final String? error;
  final T? result;

  DatabaseResponseObject.success({this.result}) : success = true, error = null;

  DatabaseResponseObject.error({this.error}) : success = false, result = null;
}
