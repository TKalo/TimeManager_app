import 'package:rxdart/rxdart.dart';
import 'package:time_manager/Database/DatabaseHandler.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';



enum routes { home, addActivity, categoryList, addCategory}

class MainViewModel {
  static final MainViewModel _singleton = MainViewModel._internal();
  factory MainViewModel() => _singleton;
  MainViewModel._internal();

  final BehaviorSubject<DateTime> _focusDay = BehaviorSubject.seeded(DateTime.now());
  Stream<DateTime> getFocusDay() => _focusDay.stream;
  void setFocusDay(DateTime dateTime) => _focusDay.add(dateTime);
  void increaseFocusDay() async => _focusDay.add((await _focusDay.first).add(const Duration(days: 1)));
  void decreaseFocusDay() async => _focusDay.add((await _focusDay.first).subtract(const Duration(days: 1)));

  Stream<List<ActivityObject>> getActivities() => DatabaseHandler().getActivities();
  Stream<List<CategoryObject>> getCategories() => DatabaseHandler().getCategories();
  void deleteActivity(ActivityObject activity) => DatabaseHandler().deleteActivity(activity);
}
