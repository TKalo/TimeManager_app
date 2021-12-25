import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/Processing/DiagramViewModel.dart';
import 'package:time_manager/Processing/MainViewModel.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/persistence/Objects/CategoryObject.dart';

import '../Pair.dart';

class Diagram extends StatelessWidget {
  const Diagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<Pair<ActivityObject,Color>>> stream = CombineLatestStream.combine3<List<ActivityObject>, DateTime, List<CategoryObject>, List<Pair<ActivityObject, Color>>>(
        MainViewModel().getActivities(), MainViewModel().getFocusDay(), MainViewModel().getCategories(),
        (List<ActivityObject> activities, DateTime? date, List<CategoryObject> categories) => DiagramViewModel().processData(activities, date ?? DateTime.now(), categories)
    );

    return StreamBuilder<List<Pair<ActivityObject, Color>>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<Pair<ActivityObject, Color>>> snapshot) {
        return SfCircularChart(
          series: <DoughnutSeries<Pair<ActivityObject,Color>, String>>[
            DoughnutSeries(
              strokeWidth: 16,
              innerRadius: '80%',
              dataSource: snapshot.data,
              xValueMapper: (Pair<ActivityObject,Color> pair, int index) => pair.first.category,
              yValueMapper: (Pair<ActivityObject,Color> pair, int index) => -pair.first.starttime.difference(pair.first.endtime).inMinutes,
              pointColorMapper: (pair, index) => pair.last,
            ),
          ],
        );
      },
    );
  }
}
