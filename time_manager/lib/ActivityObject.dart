
class ActivityObject {
  DateTime datetime;
  Duration duration;
  String category;
  String? name;
  String? description;

  ActivityObject(
      {required this.datetime,
      required this.duration,
      required this.category,
      this.name,
      this.description});

  Map<String, String> toMap() => {
      'datetime': datetime.millisecondsSinceEpoch.toString(),
      'duration': duration.inMinutes.toString(),
      'category': category,
      'name': name ?? '',
      'description': description ?? ''
    };

  ActivityObject.fromJson(Map<String, dynamic> map) :
      datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(map['datetime'] ?? '0')),
      duration = Duration(minutes: int.parse(map['duration'] ?? '0')), 
      category = map['category'] ?? '',
      name = map['name'] == '' ? null : map['name'],
      description = map['description'] == '' ? null : map['description'];
}
