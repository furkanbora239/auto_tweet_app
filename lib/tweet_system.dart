import 'dart:math';
import 'package:auto_tweet/components/get_and_save_t24_news_detail.dart';
import 'package:auto_tweet/components/save_new_news.dart';
import 'package:auto_tweet/components/send_tweet.dart';
import 'package:auto_tweet/gpt.dart' as gpt;
import 'package:flutter/material.dart';

class TweetSystem {
  int minSecont = 915;

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

  List<List>? flitterNews({required List<List<dynamic>>? news}) {
    news?.removeWhere((element) =>
        element.contains('gereksiz') ||
        element.contains('magazin') ||
        element.contains('sanat'));
    return news;
  }
}
