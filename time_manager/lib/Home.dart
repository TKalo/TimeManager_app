import 'package:flutter/material.dart';
import 'package:time_manager/Routing.dart';

import 'Body.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: const Body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setCurrentView(routes.addActivity);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
