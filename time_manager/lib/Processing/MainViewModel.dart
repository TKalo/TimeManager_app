import 'package:rxdart/rxdart.dart';
import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/StorageHandler.dart';

enum routes { home, addActivity }

class MainViewModel {
  static final MainViewModel _singleton = MainViewModel._internal();
  factory MainViewModel() => _singleton;
  MainViewModel._internal();

  final BehaviorSubject<DateTime> _focusDay = BehaviorSubject.seeded(DateTime.now());
  Stream<DateTime> getFocusDay() => _focusDay.stream;
  void setFocusDay(DateTime dateTime) => _focusDay.add(dateTime);
  void increaseFocusDay() async => (await _focusDay.first).add(const Duration(days: 1));
  void decreaseFocusDay() async => (await _focusDay.first).subtract(const Duration(days: 1));

  StorageHandler storage = StorageHandler();

  Stream<List<ActivityObject>> getActivities() => storage.getActivities();
  void deleteActivity(ActivityObject activity) => storage.deleteActivity(activity);
}
