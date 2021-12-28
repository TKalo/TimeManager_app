import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Logic/MainViewModel.dart';


class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: MainViewModel().getCategories(),
        builder: (context, AsyncSnapshot<List<CategoryObject>> snapshot) {
          List<CategoryObject> categories = snapshot.data ?? [];
    
          return ListView.builder(
            itemBuilder: (c, i) => Text(categories[i].name),
            itemCount: categories.length,
          );
        }
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, routes.addCategory.name),
        child: const Icon(Icons.add),
      ),
    );
  }
}


