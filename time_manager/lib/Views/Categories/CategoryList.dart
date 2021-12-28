import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Logic/MainViewModel.dart';
import 'package:time_manager/Utilities/ReusableWidgets.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: MainViewModel().getCategories(),
          builder: (context, AsyncSnapshot<List<CategoryObject>> snapshot) {
            List<CategoryObject> categories = snapshot.data ?? [];
    
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

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({Key? key, required this.category}) : super(key: key);

  final CategoryObject category;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<CategoryObject>(category),
      onDismissed: (DismissDirection direction) => MainViewModel().deleteCategory(category),
      confirmDismiss: (DismissDirection direction) => confirmDismiss(context),
      child: CustomListTile(
        leadingColor: Colors.red,
        title: category.name,
      ),
      background: const ListDeleteBackground(),
    );
  }

  Future<bool?> confirmDismiss(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Delete activity?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('delete')),
                TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('cancel')),
              ],
            ));
  }
}
