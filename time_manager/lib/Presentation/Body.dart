import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_manager/Presentation/Diagram.dart';
import 'package:time_manager/Processing/MainViewModel.dart';

import 'ActivityList.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Head(),
        Expanded(
          child: ActivityList(),
        )
      ],
    );
  }
}

class Head extends StatelessWidget {
  Head({Key? key}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();
  final DateFormat formatter = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(color: Colors.blue, boxShadow: [BoxShadow(color: Color(0xffd9d9d9), spreadRadius: 0, blurRadius: 8, offset: Offset(0, 7))]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => mainViewModel.decreaseFocusDay(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: Diagram()),
                Center(
                  child: StreamBuilder<DateTime>(stream: mainViewModel.getFocusDay(), builder: (context, snapshot) => Text(formatter.format(snapshot.data ?? DateTime.now()))),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () => mainViewModel.increaseFocusDay(),
            icon: const Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
