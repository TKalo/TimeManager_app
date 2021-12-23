import 'package:flutter_test/flutter_test.dart';
import 'package:time_manager/persistence/Objects/ActivityObject.dart';
import 'package:time_manager/Processing/ActivityManipulation.dart';

main() {
  ActivityObject object0 = ActivityObject(id: 0, starttime: DateTime(2000, 1, 0, 0), endtime: DateTime(2000, 1, 0, 2), category: 'category');
  ActivityObject object1 = ActivityObject(id: 0, starttime: DateTime(2000, 1, 0, 1), endtime: DateTime(2000, 1, 0, 3), category: 'category');
  ActivityObject object2 = ActivityObject(id: 0, starttime: DateTime(2000, 1, 0, 2), endtime: DateTime(2000, 1, 0, 4), category: 'category');
  ActivityObject object3 = ActivityObject(id: 0, starttime: DateTime(2000, 1, 0, 3), endtime: DateTime(2000, 1, 0, 5), category: 'category');
  ActivityObject object4 = ActivityObject(id: 0, starttime: DateTime(2000, 1, 0, 4), endtime: DateTime(2000, 1, 0, 6), category: 'category');
  ActivityObject object5 = ActivityObject(id: 0, starttime: DateTime(2000, 1, 0, 1), endtime: DateTime(2000, 1, 0, 5), category: 'category');

  group('getIntersectingActivities', (){
    test('no intersecting', () {
      List<ActivityObject> list = [object0, object4];
      ActivityObject activity = object2;
      expect(ActivityManipulation.getIntersectingActivities(list, activity).length, 0);
    });

    test('one out of 2 intersecting', () {
      List<ActivityObject> list = [object1, object2];
      ActivityObject activity = object0;
      expect(ActivityManipulation.getIntersectingActivities(list, activity).length, 1);
    });

    test('two out of 2 intersecting', () {
      List<ActivityObject> list = [object0, object2];
      ActivityObject activity = object1;
      expect(ActivityManipulation.getIntersectingActivities(list, activity).length, 2);
    });
  });

  group('cropOtherActivities', () {
    test('zero intersecting', () {
        List<ActivityObject> list = [object0, object4];
        ActivityObject activity = object2;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 2);
        expect(returnList[0].starttime, object0.starttime);
        expect(returnList[0].endtime, object0.endtime);
        expect(returnList[1].starttime, object4.starttime);
        expect(returnList[1].endtime, object4.endtime);
      });

      test('starttime within other activity', () {
        List<ActivityObject> list = [object0];
        ActivityObject activity = object1;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.starttime);
        expect(returnList[0].endtime, object1.starttime);
      });

      test('endtime within other activity', () {
        List<ActivityObject> list = [object1];
        ActivityObject activity = object0;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.endtime);
        expect(returnList[0].endtime, object1.endtime);
      });

      test('starttime at the same time as other activity starttime', () {
        List<ActivityObject> list = [object5];
        ActivityObject activity = object1;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object1.endtime);
        expect(returnList[0].endtime, object5.endtime);
      });

      test('endtime at the same time as other activity endtime', () {
        List<ActivityObject> list = [object5];
        ActivityObject activity = object3;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object3.starttime);
      });

      test('expect split in 2', () {
        List<ActivityObject> list = [object5];
        ActivityObject activity = object2;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 2);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object2.starttime);
        expect(returnList[1].starttime, object2.endtime);
        expect(returnList[1].endtime, object5.endtime);
      });

      test('object within another', () {
        List<ActivityObject> list = [object2];
        ActivityObject activity = object5;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 0);
      });

      test('object concurrent with other', () {
        List<ActivityObject> list = [object0];
        ActivityObject activity = object0;
        List<ActivityObject> returnList = ActivityManipulation.cropOtherActivities(list, activity);
        expect(returnList.length, 0);
      });
  });

  group('cropSingleActivity', (){
      test('zero intersecting', () {
        List<ActivityObject> list = [object0, object4];
        ActivityObject activity = object2;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object2.starttime);
        expect(returnList[0].endtime, object2.endtime);
      });

      test('starttime within other activity', () {
        List<ActivityObject> list = [object1];
        ActivityObject activity = object0;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.starttime);
        expect(returnList[0].endtime, object1.starttime);
      });

      test('endtime within other activity', () {
        List<ActivityObject> list = [object0];
        ActivityObject activity = object1;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object0.endtime);
        expect(returnList[0].endtime, object1.endtime);
      });

      test('starttime at the same time as other activity starttime', () {
        List<ActivityObject> list = [object1];
        ActivityObject activity = object5;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object1.endtime);
        expect(returnList[0].endtime, object5.endtime);
      });

      test('endtime at the same time as other activity endtime', () {
        List<ActivityObject> list = [object3];
        ActivityObject activity = object5;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 1);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object3.starttime);
      });

      test('expect split in 2', () {
        List<ActivityObject> list = [object2];
        ActivityObject activity = object5;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 2);
        expect(returnList[0].starttime, object5.starttime);
        expect(returnList[0].endtime, object2.starttime);
        expect(returnList[1].starttime, object2.endtime);
        expect(returnList[1].endtime, object5.endtime);
      });

      test('object within another', () {
        List<ActivityObject> list = [object5];
        ActivityObject activity = object2;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 0);
      });

      test('object concurrent with other', () {
        List<ActivityObject> list = [object0];
        ActivityObject activity = object0;
        List<ActivityObject> returnList = ActivityManipulation.cropSingleActivity(list, activity);
        expect(returnList.length, 0);
      });
  });
  
}
