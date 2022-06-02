import 'package:flutter/material.dart';
import 'package:time_manager/Controllers/category_viewmodel.dart';
import 'package:time_manager/Database/Objects/category.dart';
import 'package:time_manager/Utilities/widgets.dart';

class CategoryListItem extends StatelessWidget {
  const CategoryListItem({Key? key, required this.category}) : super(key: key);

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey<Category>(category),
      onDismissed: (DismissDirection direction) => CategoryViewModel().deleteCategory(category),
      confirmDismiss: (DismissDirection direction) => confirmDismiss(context),
      child: CustomListTile(
        leadingColor: category.color,
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
