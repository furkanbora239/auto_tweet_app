import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Terminal {
  static final ValueNotifier<List<String>> console =
      ValueNotifier<List<String>>(["application Start"]);

  void addString({required String text}) {
    List<String> list = console.value.toList();
    list.add(text);
    console.value = list.toList();
  }

  void clear() {
    console.value = [];
  }

  void removeLast() {
    List<String> list = console.value.toList();
    list.removeLast();
    console.value = list.toList();
  }

  void changeLast({required String text}) {
    List<String> list = console.value.toList();
    list.removeLast();
    list.add(text);
    console.value = list.toList();
  }
}
