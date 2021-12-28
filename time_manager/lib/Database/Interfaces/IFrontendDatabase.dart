
import 'package:time_manager/Database/Interfaces/IDatabase.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';

abstract class IFrontendDatabase implements IDatabase {

  @override
  Stream<List<Activity>> getActivities();

  @override
  Stream<List<Category>> getCategories();
}
