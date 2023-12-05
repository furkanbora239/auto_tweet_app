import 'package:auto_tweet/gdocs.dart';
import 'package:auto_tweet/scraper.dart';

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
