import 'package:flutter_test/flutter_test.dart';
import 'package:time_manager/Database/Objects/activity.dart';
import 'package:time_manager/Utilities/functions.dart';


main() {
  Activity object0 = Activity(id: '0', starttime: DateTime(2000, 1, 0, 0), endtime: DateTime(2000, 1, 0, 2), category: 'category');
  Activity object1 = Activity(id: '0', starttime: DateTime(2000, 1, 0, 1), endtime: DateTime(2000, 1, 0, 3), category: 'category');
  Activity object2 = Activity(id: '0', starttime: DateTime(2000, 1, 0, 2), endtime: DateTime(2000, 1, 0, 4), category: 'category');
  Activity object3 = Activity(id: '0', starttime: DateTime(2000, 1, 0, 3), endtime: DateTime(2000, 1, 0, 5), category: 'category');
  Activity object4 = Activity(id: '0', starttime: DateTime(2000, 1, 0, 4), endtime: DateTime(2000, 1, 0, 6), category: 'category');
  Activity object5 = Activity(id: '0', starttime: DateTime(2000, 1, 0, 1), endtime: DateTime(2000, 1, 0, 5), category: 'category');

  group('getIntersectingActivities', (){
    test('no intersecting', () {
      List<Activity> list = [object0, object4];
      Activity activity = object2;
      expect(getIntersectingActivities(list, activity).length, 0);
    });

    test('one out of 2 intersecting', () {
      List<Activity> list = [object1, object2];
      Activity activity = object0;
      expect(getIntersectingActivities(list, activity).length, 1);
    });

    test('two out of 2 intersecting', () {
      List<Activity> list = [object0, object2];
      Activity activity = object1;
      expect(getIntersectingActivities(list, activity).length, 2);
    });
  });

  group('cropOtherActivities', () {
    test('zero intersecting', () {
        List<Activity> list = [object0, object4];
        Activity activity = object2;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 2);
        expect(returnList[0].starttime, object0.starttime);
        expect(returnList[0].endtime, object0.endtime);
        expect(returnList[1].starttime, object4.starttime);
        expect(returnList[1].endtime, object4.endtime);
      });

      test('starttime within other activity', () {
        List<Activity> list = [object0];
        Activity activity = object1;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.starttime);
        expect(returnList[0].endtime, object1.starttime);
      });

      test('endtime within other activity', () {
        List<Activity> list = [object1];
        Activity activity = object0;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.endtime);
        expect(returnList[0].endtime, object1.endtime);
      });

      test('starttime at the same time as other activity starttime', () {
        List<Activity> list = [object5];
        Activity activity = object1;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object1.endtime);
        expect(returnList[0].endtime, object5.endtime);
      });

      test('endtime at the same time as other activity endtime', () {
        List<Activity> list = [object5];
        Activity activity = object3;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object3.starttime);
      });

      test('expect split in 2', () {
        List<Activity> list = [object5];
        Activity activity = object2;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 2);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object2.starttime);
        expect(returnList[1].starttime, object2.endtime);
        expect(returnList[1].endtime, object5.endtime);
      });

      test('object within another', () {
        List<Activity> list = [object2];
        Activity activity = object5;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 0);
      });

      test('object concurrent with other', () {
        List<Activity> list = [object0];
        Activity activity = object0;
        List<Activity> returnList = cropListOfActivities(list, activity);
        expect(returnList.length, 0);
      });
  });

  group('cropSingleActivity', (){
      test('zero intersecting', () {
        List<Activity> list = [object0, object4];
        Activity activity = object2;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object2.starttime);
        expect(returnList[0].endtime, object2.endtime);
      });

      test('starttime within other activity', () {
        List<Activity> list = [object1];
        Activity activity = object0;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.starttime);
        expect(returnList[0].endtime, object1.starttime);
      });

      test('endtime within other activity', () {
        List<Activity> list = [object0];
        Activity activity = object1;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.endtime);
        expect(returnList[0].endtime, object1.endtime);
      });

      test('starttime at the same time as other activity starttime', () {
        List<Activity> list = [object1];
        Activity activity = object5;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object1.endtime);
        expect(returnList[0].endtime, object5.endtime);
      });

      test('endtime at the same time as other activity endtime', () {
        List<Activity> list = [object3];
        Activity activity = object5;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object3.starttime);
      });

      test('expect split in 2', () {
        List<Activity> list = [object2];
        Activity activity = object5;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 2);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object2.starttime);
        expect(returnList[1].starttime, object2.endtime);
        expect(returnList[1].endtime, object5.endtime);
      });

      test('object within another', () {
        List<Activity> list = [object5];
        Activity activity = object2;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 0);
      });

      test('object concurrent with other', () {
        List<Activity> list = [object0];
        Activity activity = object0;
        List<Activity> returnList = cropSingleActivity(list, activity);
        expect(returnList.length, 0);
      });
  });
  
}
