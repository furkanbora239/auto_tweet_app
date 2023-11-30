import 'package:gsheets/gsheets.dart';
import 'package:auto_tweet/secret.dart' as secret; // use yours

class GSheetsApi {
  static final GSheets gSheets = GSheets(secret.gScredentials);

  static late final Worksheet tweetedWorkSheet;
  static late final Worksheet t24NewsDetailWorkSheet;
  static late final Worksheet t24SonDakikaWorkSheet;

  Future<String> init() async {
    try {
      tweetedWorkSheet = await getTweetedWorkSheet();
      t24NewsDetailWorkSheet = await getT24NewsDetailWorkSheet();
      t24SonDakikaWorkSheet = await getT24SonDakikaWorkSheet();

      return 'done';
    } catch (e) {
      return 'error:$e';
    }
  }

  Future<Worksheet> getTweetedWorkSheet() async {
    final Worksheet worksheet =
        await GSheetsApi().getWorkSheet(workSheetName: 'tweeted');
    worksheet.values.insertRow(1, [
      'tweet id' // Şuan için api geri ne dönecek bilmiyorum geleceğe hazırlık olması için ekledim öğrendiğinde buraya ekle TODO!
    ]);
    return worksheet;
  }

  Future<Worksheet> getT24SonDakikaWorkSheet() async {
    final Worksheet worksheet =
        await GSheetsApi().getWorkSheet(workSheetName: 'T24 Son Dakika');
    worksheet.values.insertRow(1, ['date', 'time', 'title']);
    return worksheet;
  }

  Future<Worksheet> getT24NewsDetailWorkSheet() async {
    final Worksheet worksheet =
        await GSheetsApi().getWorkSheet(workSheetName: 'T24 Detailed News');
    worksheet.values.insertRow(1, [
      'title',
      'subtitle',
      'date',
      'content',
      'media links',
      't24 category',
      'tags',
      'if tweeted tweet id'
    ]);
    return worksheet;
  }

  Future<Worksheet> getWorkSheet({required String workSheetName}) async {
    final spreadSheet = await gSheets.spreadsheet(secret.spreadSheetsId);
    try {
      return spreadSheet.worksheetByTitle(workSheetName)!;
    } catch (e) {
      return await spreadSheet.addWorksheet(workSheetName);
    }
  }

  Future<List> getLestTenNewsT24() async {
    final List lestTenList = [];
    final lastSave = await t24SonDakikaWorkSheet.values.lastRow();
    final lastSaveIndex = await t24SonDakikaWorkSheet.values
        .rowIndexOf(lastSave![3], inColumn: 4);
    for (int i = 10; i >= lestTenList.length;) {
      try {
        lestTenList.add(await t24SonDakikaWorkSheet.values
            .row(lastSaveIndex - lestTenList.length));
      } catch (e) {
        break;
      }
    }
    return lestTenList;
  }

  Future<bool> write(
      {required Worksheet worksheet, required List<List<dynamic>> data}) async {
    return await worksheet.values.appendRows(data);
  }
}
