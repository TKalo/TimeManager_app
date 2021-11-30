import 'package:flutter/material.dart';
import 'package:time_manager/AddActivity.dart';
import 'package:time_manager/Home.dart';
import 'Routing.dart';

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
      home: StreamBuilder<Widget>(
        stream: getCurrentViewStream(),
        builder: (context, AsyncSnapshot<Widget> snap) => snap.data ?? Container(),
      ),
      routes: {
        routes.home.name: (context) => const Home(),
        routes.addActivity.name: (context) => AddActivity(),
      },
    );
  }
}
