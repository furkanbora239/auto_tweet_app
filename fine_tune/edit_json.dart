import 'dart:io';
import 'dart:convert';
import 'package:auto_tweet/gdocs.dart';

main() async {
  forTweetGptJson();
}

void forTaggerJson() async {
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

void forTweetGptJson() async {
  await GSheetsApi().init();
  File fileForWrite = File('tweet.jsonl');
  IOSink sink = fileForWrite.openWrite();
  List forWrite = [];
  List<List<String>> newsDetails =
      await GSheetsApi.t24NewsDetailWorkSheet.values.allRows(fromRow: 2);
  for (var element in newsDetails) {
    var row = {
      "messages": [
        {"role": "system", "content": "tweet"},
        {
          "role": "user",
          "content":
              "başlık: ${element[1]}, alt başlık: ${element[2]}, içerik: ${element[4]}, media links: ${element[5]}, t24 kategri: ${element[6]}, tags: ${element[7]}"
        },
        {"role": "assistant", "content": ""}
      ]
    };
    forWrite.add(jsonEncode(row));
  }
  sink.writeAll(forWrite, '\n');
  await sink.flush();
  await sink.close();
}
