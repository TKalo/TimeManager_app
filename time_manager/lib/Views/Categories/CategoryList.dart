import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Logic/MainViewModel.dart';
import 'package:time_manager/Utilities/Objects.dart';
import 'package:time_manager/Views/Categories/CategoryListItem.dart';

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
