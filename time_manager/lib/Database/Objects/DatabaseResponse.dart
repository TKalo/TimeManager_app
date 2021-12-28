class DatabaseResponse<T> {
  final bool success;
  final String? error;
  final T? result;

  DatabaseResponse.success({this.result}) : success = true, error = null;

  DatabaseResponse.error({this.error}) : success = false, result = null;
}
