import 'package:flutter/material.dart';
import 'package:time_manager/database.dart';
import 'ActivityObject.dart';
import 'Navbar.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Navbar(),
        Container(
          height: 260,
          decoration: const BoxDecoration(color: Colors.blue, boxShadow: [
            BoxShadow(
                color: Color(0xffd9d9d9),
                spreadRadius: 0,
                blurRadius: 8,
                offset: Offset(0, 7))
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xffd9d9d9),
                        spreadRadius: 0,
                        blurRadius: 6)
                  ]),
              child: StreamBuilder<List<ActivityObject>>(
                stream: shared_data().getStream(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<ActivityObject>> snapshot) {
                  List<ActivityObject> data = snapshot.data ?? [];
                  final DateTime now = DateTime.now();

                  print('streambuilder data: ' + data.length.toString());

                  return ListView.separated(
                    itemBuilder: (c, i) {
                      return Text(data[i].name ?? 'noname');
                    },
                    separatorBuilder: (c, i) => Container(
                      height: 20,
                    ),
                    itemCount: data.length,
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }
}
