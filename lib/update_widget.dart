import 'dart:async';

class StringStream {
  final List<String> console = ["application Start"];
  final StreamController<List<String>> _stateStreamController =
      StreamController<List<String>>();
  StreamSink<List<String>> get eventSink => _stateStreamController.sink;
  Stream<List<String>> get eventStream => _stateStreamController.stream;

  void addString(String value) {
    console.add(value);
    eventSink.add(console);
  }

  void clearConsole() {
    console.clear();
    eventSink.add(console);
  }

  void clearLastOne() {
    console.removeLast();
    eventSink.add(console);
  }

  void clearLastAddNewString(String value) {
    console.removeLast();
    addString(value);
  }
}
