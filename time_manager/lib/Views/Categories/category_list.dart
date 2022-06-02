import 'package:flutter/material.dart';
import 'package:time_manager/Controllers/main_viewmodel.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Utilities/objects.dart';
import 'package:time_manager/Views/categories/category_list_item.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
            stream: MainViewModel().getCategories(),
            builder: (context, AsyncSnapshot<List<Category>> snapshot) {
              List<Category> categories = snapshot.data ?? [];

              return ListView.builder(
                itemBuilder: (c, i) => CategoryListItem(category: categories[i]),
                itemCount: categories.length,
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, routes.addCategory.name),
        child: const Icon(Icons.add),
      ),
    );
  }
}
