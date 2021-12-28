
import 'package:time_manager/Database/Interfaces/IDatabase.dart';
import 'package:time_manager/Database/Objects/ActivityObject.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';

abstract class IFrontendDatabase implements IDatabase {

  @override
  Stream<List<ActivityObject>> getActivities();

  @override
  Stream<List<CategoryObject>> getCategories();
}
