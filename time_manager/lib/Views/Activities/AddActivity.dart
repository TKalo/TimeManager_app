import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/Category.dart';
import 'package:time_manager/Controllers/ActivityViewModel.dart';
import 'package:time_manager/Controllers/MainViewModel.dart';
import 'package:time_manager/Utilities/Objects.dart';

class AddActivity extends StatelessWidget {
  AddActivity({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController timeContoller = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Material(
      child: Center(
        child: ListView(shrinkWrap: true, padding: const EdgeInsets.all(48), children: [
          Form(
            key: _formKey,
            child: Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              runSpacing: 32,
              direction: Axis.horizontal,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: CategoryDropDown(),
                    ),
                    IconButton(onPressed: () => Navigator.pushNamed(context, routes.categoryList.name), icon: const Icon(Icons.edit))
                  ],
                ),
                TextFormField(
                  controller: timeContoller,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(labelText: 'Activity time *', border: OutlineInputBorder()),
                  readOnly: true,
                  validator: (value) => value != null ? null : 'please pick time interval',
                  onTap: () => ActivityViewModel().pickTime(context).then((timestring) => timeContoller.text = timestring)),
                TextButton(
                  onPressed: () => onSubmitButtonPress(context),
                  child: Container(width: double.infinity, alignment: Alignment.center, height: 48, child: const Text('submit', style: TextStyle(fontSize: 18))))
              ],
            ),
          ),
        ]),
      ),
    );
  }

  void onSubmitButtonPress(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      ActivityViewModel().submitActivity(context);
    }
  }
}

class CategoryDropDown extends StatelessWidget {
  const CategoryDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Category>>(
        stream: MainViewModel().getCategories(),
        builder: (context, snapshot) {
          List<Category> categories = snapshot.data ?? [];
          return DropdownButtonFormField<Category>(
            onChanged: (item) => ActivityViewModel().activity.category = item?.name ?? '',
            validator: (value) => value != null ? null : 'please choose a category',
            items: categories
                .map((category) => DropdownMenuItem(
                      child: Text(category.name),
                      value: category,
                    ))
                .toList(),
            decoration: const InputDecoration(labelText: 'Activity Category *', border: OutlineInputBorder()),
          );
        });
  }
}
