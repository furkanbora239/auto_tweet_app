import 'dart:io';
import 'dart:convert';

main() async {
  String jsonFileString = await File("tagger.jsonl").readAsString();
  List<String> jsonLines = jsonFileString.split('\n').toList();

  List<Map> jsonMapList = [];
  for (var element in jsonLines) {
    Map jsonFile = jsonDecode(element);
    String content = jsonFile['messages'][2]['content'];
    jsonFile['messages'][2]['content'] = content.trim();
    jsonMapList.add(jsonFile);
  }
}
