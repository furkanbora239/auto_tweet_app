import 'dart:math';
import 'package:auto_tweet/components/save_new_news.dart';
import 'package:auto_tweet/components/send_tweet.dart';
import 'package:auto_tweet/gdocs.dart';
import 'package:auto_tweet/gpt.dart' as gpt;
import 'package:auto_tweet/scraper.dart';
import 'package:auto_tweet/update_widget.dart';
import 'package:flutter/material.dart';

class TweetSystem {
  int minSecont = 915;

  void auto({required BuildContext context}) async {
    StringStream().addString('waiting for gSheet init');
    while (await GSheetsApi().init() != 'done') {
      await Future.delayed(const Duration(minutes: 5));
    }
    StringStream().addString('GSheet init is done');
    while (true) {
      int nextJopTime = minSecont + Random().nextInt(360);
      StringStream().addString('Next jop time is $nextJopTime');

      final List<List<dynamic>>? lastSavedNews = await saveNewNews();
      final List<List<dynamic>>? flitteredNews =
          TweetSystem().flitterNews(news: lastSavedNews);
      List<List<String>> saveNewsDetail = [];
      if (flitteredNews != null && flitteredNews.isNotEmpty) {
        for (var element in flitteredNews) {
          final Map<String, Object?> newDetails =
              await T24().haberDetay(link: Uri.parse(element[3]));
          String tweet = await gpt.makeTweet(
              text:
                  "başlık: ${newDetails['title'].toString()}, alt başlık: ${newDetails['subtitle'].toString()}, içerik: ${newDetails['content'].toString()}, media links: ${newDetails['mediaLinks'].toString()}, t24 kategri: ${newDetails['T24Category'].toString()}, tags: ${(element.getRange(4, element.length).join(" "))}");
          // ignore: use_build_context_synchronously
          sendTweet(tweetText: tweet, context: context);
          saveNewsDetail.add([
            element[3].toString(),
            newDetails['title'].toString(),
            newDetails['subtitle'].toString(),
            newDetails['date'].toString(),
            newDetails['content'].toString(),
            newDetails['mediaLinks'].toString(),
            newDetails['T24Category'].toString(),
            (element.getRange(4, element.length).join(" ")),
            'şimdilik boş',
            tweet
          ]);
          await Future.delayed(
              Duration(seconds: (nextJopTime / flitteredNews.length).round()));
        }
        GSheetsApi().write(
            worksheet: GSheetsApi.t24NewsDetailWorkSheet, data: saveNewsDetail);
      } else {
        await Future.delayed(Duration(seconds: nextJopTime));
      }
    }
  }

  List<List>? flitterNews({required List<List<dynamic>>? news}) {
    news?.removeWhere((element) =>
        element.contains('gereksiz') ||
        element.contains('gezi') ||
        element.contains('magazin') ||
        element.contains('sanat'));
    return news;
  }
}

void getNewNewsAndSaveDetails() async {
  final List<List<dynamic>>? lastSavedNews = await saveNewNews();
  final List<List<dynamic>>? flitteredNews =
      TweetSystem().flitterNews(news: lastSavedNews);
  List<List<String>> saveNewsDetail = [];
  if (flitteredNews != null && flitteredNews.isNotEmpty) {
    for (var element in flitteredNews) {
      final Map<String, Object?> newDetails =
          await T24().haberDetay(link: Uri.parse(element[3]));
      saveNewsDetail.add([
        element[3].toString(),
        newDetails['title'].toString(),
        newDetails['subtitle'].toString(),
        newDetails['date'].toString(),
        newDetails['content'].toString(),
        newDetails['media links'].toString(),
        newDetails['T24Category'].toString(),
        (element.getRange(4, element.length).join(" ")),
        'şimdilik boş'
      ]);
    }
    GSheetsApi().write(
        worksheet: GSheetsApi.t24NewsDetailWorkSheet, data: saveNewsDetail);
  }
}
