import 'package:mongo_dart/mongo_dart.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Database/Objects/DatabaseResponse.dart';

class CategoryDatabase {
  Future<Db> db;
  Future<DbCollection> collection;
  CategoryDatabase({required this.db}) : collection = db.then((db) => db.collection('categories'));

  Future<DatabaseResponse<void>> add(Category category) async {
    final col = await collection;

    final map = category.toMap();

    map.addAll({'_id': ObjectId().toString()});

    await col.insert(map);

    return DatabaseResponse.success(result: null);
  }

  Future<DatabaseResponse<void>> update(Category category) async {
    final col = await collection;

    category.toMap().forEach((k, v) {
      if (k == '_id') return;

      col.update(where.eq('_id', category.id), modify.set(k, v));
    });

    return DatabaseResponse.success(result: null);
  }

  Future<DatabaseResponse<List<Category>>> get() async {
    final col = await collection;

    List<Category> categories = await col.find().map((category) => Category.fromJson(category)).toList();

    return DatabaseResponse.success(result: categories);
  }

  Future<DatabaseResponse<void>> delete(Category category) async {
    final col = await collection;

    col.remove(where.eq('_id', category.id));

    return DatabaseResponse.success(result: null);
  }
}
