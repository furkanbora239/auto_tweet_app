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
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: FilledButton(
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Colors.indigo)),
            onPressed: () {
              /* showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(const Duration(seconds: 20), () {
                    Navigator.pop(context);
                  });
                  return SendTweet(
                      url: Uri.parse(
                          '''https://twitter.com/compose/tweet?&text=Merhaba %23dünya bununla beraber tweet ortasında hashtag meselesini çözmüş oldum.'''));
                },
              ); */
              saveNewNews();
            },
            child: const Text(
              'send tweet',
              style: TextStyle(color: Colors.brown),
            )),
      ),
    );
  }
}

void saveNewNews() async {
  var sonDakika = await T24().sonDakika();
  var lastTenNews = await GSheetsApi().getLestTenNews();
  for (int i = 0; i < lastTenNews.length; i++) {
    for (int s = 0; s < sonDakika.length; s++) {
      if (lastTenNews[i][2] == sonDakika[s]['title']) {
        sonDakika.removeRange(s, sonDakika.length);
        break;
      }
    }
  }
  List<List<dynamic>> saveSonDakika = [];
  for (var element in sonDakika) {
    saveSonDakika.add([
      '',
      element["time"].toString(),
      element["title"].toString(),
      element["link"].toString()
    ]);
    saveSonDakika.last.insertAll(saveSonDakika.last.length,
        await gpt.tagger(title: element['title'].toString()));
  }
  if (saveSonDakika.isNotEmpty) {
    saveSonDakika.first.first = DateTime.now().toIso8601String();
    GSheetsApi().write(
        worksheet: GSheetsApi.t24SonDakikaWorkSheet,
        data: saveSonDakika.reversed.toList());
  }
}
