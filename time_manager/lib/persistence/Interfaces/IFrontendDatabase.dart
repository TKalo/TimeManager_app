import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/Interfaces/IDatabase.dart';

abstract class IFrontendDatabase implements IDatabase {

  @override
  Stream<List<ActivityObject>> getActivities();
}
