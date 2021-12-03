
class ActivityObject {
  DateTime starttime;
  DateTime endtime;
  String category;
  String? name;
  String? description;

  ActivityObject(
      {required this.starttime,
      required this.endtime,
      required this.category,
      this.name,
      this.description});

  Map<String, String> toMap() => {
      'starttime': starttime.millisecondsSinceEpoch.toString(),
      'endtime': endtime.microsecondsSinceEpoch.toString(),
      'category': category,
      'name': name ?? '',
      'description': description ?? ''
    };

  ActivityObject.fromJson(Map<String, dynamic> map) :
      starttime = DateTime.fromMillisecondsSinceEpoch(int.parse(map['starttime'] ?? '0')),
      endtime = DateTime.fromMillisecondsSinceEpoch(int.parse(map['endtime'] ?? '0')),
      category = map['category'] ?? '',
      name = map['name'] == '' ? null : map['name'],
      description = map['description'] == '' ? null : map['description'];
}
