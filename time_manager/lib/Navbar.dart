
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: Colors.blue,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AspectRatio(
            aspectRatio: 1.0,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_forward,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
