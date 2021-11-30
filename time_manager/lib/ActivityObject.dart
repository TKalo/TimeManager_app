
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
  

  static ActivityObject fromMap(Map<String, dynamic> map) {
    if(map['datetime'] == null || map['duration'] == null || map['category'] == null) NullThrownError();
    return ActivityObject(
        datetime: DateTime.fromMillisecondsSinceEpoch(int.parse(map['datetime'] ?? '0')), 
        duration: Duration(minutes: int.parse(map['datetime'] ?? '0')), 
        category: map['category'] ?? '',
        name: map['name'] == '' ? null : map['name'],
        description: map['description'] == '' ? null : map['description']
      );
  }
}
