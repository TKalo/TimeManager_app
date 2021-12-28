import 'package:flutter/material.dart';
import 'package:time_manager/Utilities/routes.dart';
import 'ActivityList.dart';
import 'Head.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: Column(
        children: [
          Head(),
          Expanded(
            child: ActivityList(),
          )
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, routes.addActivity.name),
        child: const Icon(Icons.add),
      ),
    );
  }
}

