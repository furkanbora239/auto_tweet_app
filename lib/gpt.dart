import 'dart:convert';

import 'package:auto_tweet/secret.dart'
    as secret; // i have a scret file for api keys etc..
import 'package:http/http.dart' as http;

Future makeTweet({required String text}) async {
  http.Response response =
      await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${secret.bearerToken}' //use your bearer token
          },
          body: jsonEncode({
            "model": "gpt-3.5-turbo",
            "messages": [
              {"role": "system", "content": 'Summary'},
              {"role": "user", "content": text}
            ],
            "temperature": 0.5
          }));
  var content = jsonDecode(utf8.decode(response.bodyBytes));
  return content['choices'][0]['message']['content'].toString();
}

Future _tagger({required String title}) async {
  http.Response response =
      await http.post(Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ${secret.bearerToken}' //use your bearer token
          },
          body: jsonEncode({
            "model": "ft:gpt-3.5-turbo-1106:personal::8RtJNIHf",
            "messages": [
              {"role": "system", "content": 'tagger'},
              {"role": "user", "content": title}
            ],
            "temperature": 0
          }));
  var content = jsonDecode(utf8.decode(response.bodyBytes));
  return content['choices'][0]['message']['content'].toString();
}

Future<List<String>> tagger({required String title}) async {
  List<String> tags = [];
  String gptTag = await _tagger(title: title.toString());
  if (gptTag.contains(' ')) {
    tags = gptTag.split(' ');
  } else {
    tags.add(gptTag);
  }
  return tags;
}
