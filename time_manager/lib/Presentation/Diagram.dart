import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:time_manager/Processing/DiagramViewModel.dart';
import 'package:time_manager/Processing/MainViewModel.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';


class Diagram extends StatelessWidget {
  const Diagram({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Stream<List<ActivityObject>> stream = CombineLatestStream.combine2<List<ActivityObject>,DateTime, List<ActivityObject>>(MainViewModel().getActivities(), MainViewModel().getFocusDay(), (List<ActivityObject> activities ,DateTime? date) => DiagramViewModel().processData(activities, date ?? DateTime.now()));
    
    return StreamBuilder<List<ActivityObject>>(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot<List<ActivityObject>> snapshot) {
        return SfCircularChart(
          series: <DoughnutSeries<ActivityObject, String>>[
            DoughnutSeries(
                dataSource: snapshot.data,
                xValueMapper: (ActivityObject object, int index) => object.category,
                yValueMapper: (ActivityObject object, int index) => -object.starttime.difference(object.endtime).inMinutes)
          ],
        );
      },
    );
  }
}
