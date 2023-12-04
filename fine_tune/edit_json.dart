import 'dart:io';
import 'dart:convert';

main() async {
  String jsonFileString = await File("tagger.jsonl").readAsString();
  List<String> jsonLines = jsonFileString.split('\n');

  File fileForWrite = File('tagger.jsonl');
  var sink = fileForWrite.openWrite();
  List forWrite = [];
  for (var i = 0; i < jsonLines.length; i++) {
    Map jsonFile = jsonDecode(jsonLines[i].trim());
    print(jsonFile);
    String content = jsonFile['messages'][2]['content'];
    jsonFile['messages'][2]['content'] = content.trim();
    forWrite.add(jsonEncode(jsonFile));
  }
  sink.writeAll(forWrite, '\n');

  await sink.flush();
  await sink.close();
}
