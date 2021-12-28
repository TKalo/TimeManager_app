import 'package:flutter/material.dart';
import 'package:time_manager/Logic/MainViewModel.dart';
import 'Diagram.dart';

class Head extends StatelessWidget {
  const Head({Key? key}) : super(key: key);

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
            onPressed: () => MainViewModel().decreaseFocusDay(),
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
                const Expanded(child: Diagram()),
                Center(
                  child: StreamBuilder<DateTime>(
                    stream: MainViewModel().getFocusDay(), 
                    builder: (context, snapshot) => Text(MainViewModel().formatter.format(snapshot.data ?? DateTime.now()))
                  ),
                )
              ],
            ),
          ),
          IconButton(
            onPressed: () => MainViewModel().increaseFocusDay(),
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
