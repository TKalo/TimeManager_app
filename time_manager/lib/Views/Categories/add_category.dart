import 'package:flutter/material.dart';
import 'package:time_manager/Controllers/category_viewmodel.dart';

class AddCategory extends StatelessWidget {
  AddCategory({Key? key}) : super(key: key);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController colorCotroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Center(
      child: ListView(padding: const EdgeInsets.all(48), shrinkWrap: true, children: [
        Form(
            key: _formKey,
            child: Wrap(alignment: WrapAlignment.center, runAlignment: WrapAlignment.center, runSpacing: 32, direction: Axis.horizontal, children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'name', border: OutlineInputBorder()),
                maxLength: 30,
                onChanged: (string) => CategoryViewModel().category.name = string,
                validator: (string) => (string == null || string.length < 2) ? 'name to short' : null,
              ),
              TextFormField(
                  controller: colorCotroller,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(labelText: 'color', border: OutlineInputBorder()),
                  readOnly: true,
                  validator: (string) => (string == null || string.isEmpty) ? 'pick a color' : null,
                  onTap: () => CategoryViewModel().pickColor(context).then((colorString) => colorCotroller.text = colorString ?? colorCotroller.text)),

              TextButton(
                  onPressed: () => onSubmitButtonPress(context),
                  child: Container(width: double.infinity, alignment: Alignment.center, height: 48, child: const Text('submit', style: TextStyle(fontSize: 18)))),

              StreamBuilder<String?>(
                  stream: CategoryViewModel().globalError,
                  builder: (context, AsyncSnapshot<String?> snapshot) {
                    return snapshot.data == null ? Container() : Text(snapshot.data ?? 'internal error', style: const TextStyle(color: Colors.redAccent));
                  })
              //time
            ]))
      ]),
    ));
  }

  void onSubmitButtonPress(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      CategoryViewModel().submitActivity(context);
    }
  }
}
