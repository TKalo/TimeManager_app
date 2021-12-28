import 'package:flutter/material.dart';
import 'package:time_manager/Presentation/Categories/CategoryList.dart';
import 'package:time_manager/Utilities/routes.dart';
import 'package:time_manager/Views/Categories/AddCategory.dart';
import 'package:time_manager/Views/Activities/AddActivity.dart';
import 'package:time_manager/Views/Home/Home.dart';


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
