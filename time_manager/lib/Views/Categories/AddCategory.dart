import 'package:flutter/material.dart';
import 'package:time_manager/Database/Objects/CategoryObject.dart';
import 'package:time_manager/Logic/AddCategoryViewModel.dart';


class AddCategory extends StatelessWidget {
  AddCategory({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CategoryObject category = CategoryObject(name: '', color: Colors.grey);
  final TextEditingController colorCotroller = TextEditingController();

 @override
  Widget build(BuildContext context) {
    return Material(
        child: ListView(padding: const EdgeInsets.all(48), children: [
      Form(
          key: _formKey,
          child: Wrap(alignment: WrapAlignment.center, runAlignment: WrapAlignment.center, runSpacing: 32, direction: Axis.horizontal, children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Category name', border: OutlineInputBorder()),
              maxLength: 30,
              onChanged: (string) => category.name = string,
            ),
            TextFormField(
                controller: colorCotroller,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(labelText: 'Activity time', border: OutlineInputBorder()),
                readOnly: true,
                onTap: () => AddCategoryViewModel().pickColor(context).then((colorString) => colorCotroller.text = colorString ?? colorCotroller.text)),
          
            TextButton(
                  onPressed: () => onSubmitButtonPress(context),
                  child: Container(width: double.infinity, alignment: Alignment.center, height: 48, child: const Text('submit', style: TextStyle(fontSize: 18))))
              //time
          ]))
    ]));
  }

  void onSubmitButtonPress(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      //AddCategoryViewModel().submitActivity(context);
    }
  }
}
