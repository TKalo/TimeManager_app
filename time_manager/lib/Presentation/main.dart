import 'package:flutter/material.dart';
import 'package:time_manager/Presentation/AddCategory.dart';
import 'package:time_manager/Presentation/CategoryList.dart';
import 'package:time_manager/Presentation/Home.dart';
import 'package:time_manager/Processing/MainViewModel.dart';

import 'AddActivity.dart';


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
