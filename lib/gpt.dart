import 'dart:convert';

import 'package:auto_tweet/secret.dart'
    as secret; // i have a scret file for api keys etc..
import 'package:http/http.dart' as http;

Future makeTweet({required String send}) async {
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
              {"role": "system", "content": ''},
              {"role": "user", "content": send}
            ],
            "temperature": 0.5
          }));
  return jsonDecode(utf8.decode(response.bodyBytes));
}
