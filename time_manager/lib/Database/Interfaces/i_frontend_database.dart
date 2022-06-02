
import 'package:time_manager/Database/Interfaces/i_database.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/category.dart';

abstract class IFrontendDatabase implements IDatabase {

  @override
  Stream<List<Activity>> getActivities();

  @override
  Stream<List<Category>> getCategories();
}
