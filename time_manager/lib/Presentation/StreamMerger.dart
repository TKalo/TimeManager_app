import 'package:rxdart/rxdart.dart';
import 'package:synchronized/synchronized.dart';

class StreamMerger {
  final BehaviorSubject<Map<String, dynamic>> _valuesStream = BehaviorSubject();
  final Map<String, dynamic> _values = {};
  final _lock = Lock();

  StreamMerger(Map<String, Stream> streams) {
    streams.forEach((key, stream) {
      stream.listen((value) {
        _lock.synchronized(() {
          _values.update(key, (_) => value, ifAbsent: () => value);
          _valuesStream.add(_values);
        });
      });
    });
  }

  Stream<Map<String, dynamic>> get getStream => _valuesStream.stream;
}
