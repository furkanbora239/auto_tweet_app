import 'dart:math';

import 'package:auto_tweet/components/save_new_news.dart';
import 'package:auto_tweet/components/send_tweet.dart';
import 'package:auto_tweet/gdocs.dart';
import 'package:auto_tweet/scraper.dart';
import 'package:flutter/material.dart';
import 'package:auto_tweet/gpt.dart' as gpt;

void main() {
  GSheetsApi().init();
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TweetSystem().auto(context: context);
    return const ColoredBox(color: Colors.black);
  }
}

class TweetSystem {
  int minSecont = 915;
  bool unWanted(List element, {required String tagName}) {
    return !element.contains(tagName);
  }

  void auto({required BuildContext context}) async {
    while (true) {
      int nextJopTime = minSecont + Random().nextInt(360);
      List<List>? savedNewNews = await saveNewNews();
      savedNewNews?.removeWhere((element) =>
          element.contains('gereksiz') ||
          element.contains('magazin') ||
          element.contains('sanat'));
      if (savedNewNews != null && savedNewNews.isNotEmpty) {
        for (var row in savedNewNews) {
          Map newsDetail = await getAndSaveT24NewsDetail(row: row);
          String tweet = await gpt.makeTweet(
              text:
                  '''başlık: ${newsDetail['title']}, altbaşlık: ${newsDetail['subtitle']}, metin: ${newsDetail['content']}, media linkleri: ${newsDetail['media links']}, t24 kategorisi: ${newsDetail['t24 category']}''');
          sendTweet(tweetText: tweet, context: context);

          await Future.delayed(
              Duration(seconds: (nextJopTime / savedNewNews.length).round()));
        }
      }
    }
  }
}

Future<Map<String, Object?>> getAndSaveT24NewsDetail(
    {required List<dynamic> row}) async {
  Uri url = Uri.parse(row[3]);
  Map<String, Object?> newsDetail = await T24().haberDetay(link: url);
  List<String> newsDetailList = [
    newsDetail['title'].toString(),
    newsDetail['subtitle'].toString(),
    newsDetail['date'].toString(),
    newsDetail['content'].toString(),
    newsDetail['media links'].toString(),
    newsDetail['t24 category'].toString(),
    (row.getRange(4, row.length - 1).join(" ")),
    'şimdilik boş'
  ];

  GSheetsApi().write(
      worksheet: GSheetsApi.t24NewsDetailWorkSheet, data: [newsDetailList]);
  return newsDetail;
}
