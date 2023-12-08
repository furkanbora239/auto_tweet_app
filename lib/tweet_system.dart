import 'dart:math';
import 'package:auto_tweet/components/save_new_news.dart';
import 'package:auto_tweet/components/send_tweet.dart';
import 'package:auto_tweet/gdocs.dart';
import 'package:auto_tweet/gpt.dart' as gpt;
import 'package:auto_tweet/scraper.dart';
import 'package:flutter/material.dart';

class TweetSystem {
  int minSecont = 915;

  void auto({required BuildContext context}) async {
    while (true) {
      int nextJopTime = minSecont + Random().nextInt(360);

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
