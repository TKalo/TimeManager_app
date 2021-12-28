import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/Database/Objects/Activity.dart';
import 'package:time_manager/Database/Objects/Category.dart';

import 'package:time_manager/Controllers/MainViewModel.dart';
import 'package:time_manager/Utilities/Functions.dart';
import 'package:time_manager/Utilities/Objects.dart';

class Diagram extends StatelessWidget {
  const Diagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Stream<List<Pair<Activity, Color?>>> stream = CombineLatestStream.combine3<List<Activity>, DateTime, List<Category>, List<Pair<Activity, Color?>>>(
        MainViewModel().getActivities(),
        MainViewModel().getFocusDay(),
        MainViewModel().getCategories(),
        (List<Activity> activities, DateTime? date, List<Category> categories) => getDiagramData(activities, date ?? DateTime.now(), categories));

    return StreamBuilder<List<Pair<Activity, Color?>>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<Pair<Activity, Color?>>> snapshot) {
        return SfCircularChart(
          series: <DoughnutSeries<Pair<Activity, Color?>, String>>[
            DoughnutSeries(
              strokeWidth: 16,
              innerRadius: '80%',
              dataSource: snapshot.data,
              xValueMapper: (Pair<Activity, Color?> pair, int index) => pair.first.category,
              yValueMapper: (Pair<Activity, Color?> pair, int index) => -pair.first.starttime.difference(pair.first.endtime).inMinutes,
              pointColorMapper: (pair, index) => pair.last ?? Colors.transparent,
            ),
          ],
        );
      },
    );
  }
}
