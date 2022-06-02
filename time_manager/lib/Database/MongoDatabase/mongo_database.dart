import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:time_manager/Database/Interfaces/i_backend_database.dart';
import 'package:time_manager/Database/MongoDatabase/activity_database.dart';
import 'package:time_manager/Database/MongoDatabase/category_database.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';

class MongoDatabase implements IBackendDatabase {
  final ActivityDatabase _activityDB;
  final CategoryDatabase _categoryDB;

  MongoDatabase({Future<Db>? db})
      : _activityDB = ActivityDatabase(db: db ??= getConnection()),
        _categoryDB = CategoryDatabase(db: db);

  @override
  Future<DatabaseResponse<void>> addCategory(Category category) => _categoryDB.add(category);

  @override
  Future<DatabaseResponse<void>> deleteCategory(Category category) => _categoryDB.delete(category);

  @override
  Future<DatabaseResponse<List<Category>>> getCategories() => _categoryDB.get();

  @override
  Future<DatabaseResponse<void>> updateCategory(Category category) => _categoryDB.update(category);

  @override
  Future<DatabaseResponse<String>> addActivity(Activity activity) => _activityDB.add(activity);

  @override
  Future<DatabaseResponse<void>> deleteActivity(Activity activity) => _activityDB.update(activity);

  @override
  Future<DatabaseResponse<List<Activity>>> getActivities() => _activityDB.get();

  @override
  Future<DatabaseResponse<void>> updateActivity(Activity activity) => _activityDB.delete(activity);

  static Future<Db> getConnection() async {
    await dotenv.load(fileName: '.env');
    final password = dotenv.get('MONGO_DB_PASSWORD');
    final connectionString = "mongodb+srv://gorrmy:$password@sphericalworks.sa103.mongodb.net/time_manager_db";

    print(connectionString);
    Db db = await Db.create(connectionString);
    await db.open();
    return db;
  }
}
