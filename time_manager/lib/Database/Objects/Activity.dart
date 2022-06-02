class Activity {
  String id;
  DateTime starttime;
  DateTime endtime;
  String category;
  String name;
  String description;

  Activity({this.id = '', required this.starttime, required this.endtime, required this.category, this.name = '', this.description = ''});

  Map<String, String> toMap() =>
      {'starttime': starttime.millisecondsSinceEpoch.toString(), 'endtime': endtime.millisecondsSinceEpoch.toString(), 'category': category, 'name': name, 'description': description, '_id': id.toString()};

  Activity.fromJson(Map<String, dynamic> map)
      : id = map['_id'] ?? '',
        starttime = DateTime.fromMillisecondsSinceEpoch(int.parse(map['starttime'] ?? '0')),
        endtime = DateTime.fromMillisecondsSinceEpoch(int.parse(map['endtime'] ?? '0')),
        category = map['category'] ?? '',
        name = map['name'] ?? '',
        description = map['description'] ?? '';
  
  Activity copy() => Activity(starttime: starttime, endtime: endtime, category: category, name: name, description: description);
}
