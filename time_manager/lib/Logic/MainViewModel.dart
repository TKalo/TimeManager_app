import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_manager/Database/DatabaseHandler.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Utilities/Values.dart';

class MainViewModel {
  static final MainViewModel _singleton = MainViewModel._internal();
  factory MainViewModel() => _singleton;
  MainViewModel._internal();

  final BehaviorSubject<DateTime> _focusDay = BehaviorSubject.seeded(DateTime.now());

  Stream<DateTime> getFocusDay() => _focusDay.stream;

  void increaseFocusDay() async => _focusDay.add((await _focusDay.first).add(const Duration(days: 1)));

  void decreaseFocusDay() async => _focusDay.add((await _focusDay.first).subtract(const Duration(days: 1)));

  Stream<List<Activity>> getActivities() => DatabaseHandler().getActivities();

  Stream<List<Category>> getCategories() => DatabaseHandler().getCategories();

  DateFormat formatter = DateFormat(Values.dateFormat);
}
