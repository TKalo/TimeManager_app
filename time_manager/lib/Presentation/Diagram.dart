import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/Presentation/main.dart';
import 'package:time_manager/Processing/MainViewModel.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:async/async.dart' show StreamGroup;

import '../helpers.dart';
import 'StreamMerger.dart';

class Diagram extends StatelessWidget {
  Diagram({Key? key}) : super(key: key);

  final MainViewModel mainViewModel = MainViewModel();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<String, dynamic>>(
      stream: StreamMerger({'activities': mainViewModel.getActivities(), 'datetime': mainViewModel.getFocusDay()}).getStream,
      builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.data == null || snapshot.data == {}) return Container();
        
        DateTime selectedDate = snapshot.data?['datetime'] as DateTime;
        List<ActivityObject> data = getSelectedDateActivities(snapshot.data?['activities'] as List<ActivityObject>, selectedDate);
        data.sort((a, b) => a.starttime.compareTo(b.starttime));

        return SfCircularChart(
          series: <DoughnutSeries<ActivityObject, String>>[
            DoughnutSeries(
                dataSource: data,
                xValueMapper: (ActivityObject object, int index) => object.category,
                yValueMapper: (ActivityObject object, int index) => -object.starttime.difference(object.endtime).inMinutes)
          ],
        );
      },
    );
  }
}
