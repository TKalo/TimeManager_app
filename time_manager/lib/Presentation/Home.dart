import 'package:flutter/material.dart';
import 'package:time_manager/Processing/MainViewModel.dart';

import 'Body.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      body: const Body(),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, routes.addActivity.name),
        child: const Icon(Icons.add),
      ),
    );
  }
}
