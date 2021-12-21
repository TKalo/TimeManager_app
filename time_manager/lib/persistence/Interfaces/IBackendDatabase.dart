import 'package:time_manager/persistence/ActivityObject.dart';
import 'package:time_manager/persistence/Interfaces/IDatabase.dart';

import '../DatabaseResponseObject.dart';

abstract class IBackendDatabase implements IDatabase {

  @override
  Future<DatabaseResponseObject<List<ActivityObject>>> getActivities();
}
