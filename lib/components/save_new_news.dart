import 'package:auto_tweet/gdocs.dart';
import 'package:auto_tweet/gpt.dart' as gpt;
import 'package:auto_tweet/scraper.dart';

Future<List<List>?> saveNewNews() async {
  var sonDakika = await T24().sonDakika();
  var lastTenNews = await GSheetsApi().getLestTenNewsT24();
  comparison:
  for (int i = 0; i < lastTenNews.length; i++) {
    for (int s = 0; s < sonDakika.length; s++) {
      if (lastTenNews[i][2] == sonDakika[s]['title']) {
        sonDakika.removeRange(s, sonDakika.length);
        break comparison;
      }
    }
  }
  List<List<String>> saveSonDakika = [];
  if (sonDakika.isNotEmpty) {
    //convert map to list
    for (var element in sonDakika) {
      saveSonDakika.add([
        '',
        element["time"].toString(),
        element["title"].toString(),
        element["link"].toString()
      ]);
      //add tags to list
      saveSonDakika.last.insertAll(saveSonDakika.last.length,
          await gpt.tagger(title: element['title'].toString()));
    }
  }
  if (saveSonDakika.isNotEmpty) {
    saveSonDakika.first.first = DateTime.now().toIso8601String();
    GSheetsApi().write(
        worksheet: GSheetsApi.t24SonDakikaWorkSheet,
        data: saveSonDakika.reversed.toList());
    return saveSonDakika.reversed.toList();
  }
  return null;
}
