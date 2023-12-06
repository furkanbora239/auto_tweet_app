import 'package:auto_tweet/components/get_and_save_t24_news_detail.dart';
import 'package:auto_tweet/components/save_new_news.dart';
import 'package:auto_tweet/tweet_system.dart';

void saveNewNewsDetails() async {
  List<List<dynamic>>? newNews = await saveNewNews();
  print('saving new news');
  List<List<dynamic>>? flitteredNews = TweetSystem().flitterNews(news: newNews);
  print('flittering news');
  if (flitteredNews != null && flitteredNews.isNotEmpty) {
    for (var element in flitteredNews) {
      getAndSaveT24NewsDetail(row: element);
      print('saving news detail: title: ${element.first}');
    }
  }
}
