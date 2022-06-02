import 'package:flutter/material.dart';
import 'package:time_manager/Utilities/objects.dart';
import 'package:time_manager/Views/Categories/add_category.dart';
import 'package:time_manager/Views/Activities/add_activity.dart';
import 'package:time_manager/Views/Categories/category_list.dart';
import 'package:time_manager/Views/Home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
      routes: {
        routes.home.name: (context) => const Home(),
        routes.addActivity.name: (context) => AddActivity(),
        routes.categoryList.name: (context) => const CategoryList(),
        routes.addCategory.name: (context) => AddCategory(),
      },
    );
  }
}
