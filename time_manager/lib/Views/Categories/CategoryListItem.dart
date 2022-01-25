import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Controllers/CategoryViewModel.dart';
import 'package:time_manager/Utilities/Widgets.dart';

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
