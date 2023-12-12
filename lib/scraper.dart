import 'dart:convert';
import 'package:auto_tweet/update_widget.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart';

class T24 {
  Future<List<Map<String, Object>>> sonDakika() async {
    Terminal().addString(text: "geting hot news from t24");
    List<Map<String, Object>> breakingNews = [];
    final http.Response response =
        await _getWebSite(url: Uri.parse('https://t24.com.tr/son-dakika'));
    final Document html = Document.html(utf8.decode(response.bodyBytes));
    final List<Element> haberData =
        html.querySelectorAll('div._1N_iq > div > div._1qLBI').toList();
    for (var element in haberData) {
      final String time = element.querySelector(' a > p.jo5wf')!.text;
      final String title = element.querySelector("a > h3.u2F6W")!.text;
      final Uri link = Uri.parse(
          "https://t24.com.tr${element.querySelector('a')!.attributes['href']}");
      breakingNews.add({"time": time, "title": title, "link": link});
    }
    return breakingNews;
  }

  Future<http.Response> _getWebSite({required Uri url}) async {
    bool done = false;
    late http.Response response;
    while (!done) {
      try {
        response = await http.get(url);
        if (response.statusCode == 200) {
          done = true;
          Terminal().addString(text: "get website is done");
        } else {
          Terminal().addString(
              text:
                  "get error status code: ${response.statusCode} \n detail: \n${response.body}\n retry in 5 min.");
          await Future.delayed(const Duration(minutes: 5));
        }
      } catch (e) {
        Terminal().addString(
            text: "get web site error. error code: \n $e \n retry in 5 min.");
        await Future.delayed(const Duration(minutes: 5));
      }
    }
    return response;
  }

  Future<Map<String, Object?>> haberDetay({required Uri link}) async {
    late String date;
    late String title;
    String? subtitle;
    late final String t24Category;
    final http.Response response = await http.get(link);
    final Document html = Document.html(utf8.decode(response.bodyBytes));
    final String croppedLink =
        link.toString().replaceFirst('https://t24.com.tr/', '');
    String content = '';
    List mediaLinks = [];
    if (croppedLink.startsWith('video')) {
      t24Category = 'video';
      date = html
          .querySelector(
              "div._3mmXU > div._1XNyq > div._2l0_f > div > div._392lz > p")!
          .text;
      title =
          html.querySelector("div.col-md-8.col-xs-12 > div._3mmXU > h1")!.text;
      mediaLinks.add(link
          .toString()); // twitter automatically finds the video. so it is enough to use the link to the web page
      if (title.contains("Türkiye ve dünya gündeminde neler oldu?")) {
        final contentData = html
            .querySelectorAll(
                "div._3mmXU > div._1NMxy > div > ul > li > strong")
            .toList();
        for (var element in contentData) {
          content += element.text;
          content += '\n';
        }
      } else {
        final contentData =
            html.querySelectorAll('div._3mmXU > div._1NMxy > div > p').toList();
        for (var element in contentData) {
          content += element.text;
          content += '\n';
        }
      }
    } else if (croppedLink.startsWith('haber')) {
      t24Category = 'haber';

      date = html
          .querySelector(
              "div._1d1Rj > div > div._2l0_f > div > div._392lz > p")!
          .text;
      title = html
          .querySelector("div.col-md-8.col-xs-12 > div > div.d0FP9 > h1")!
          .text;
      subtitle = html
          .querySelector("div.col-md-8.col-xs-12 > div > div.d0FP9 > h2")
          ?.text;

      final contentData =
          html.querySelectorAll('div._3QVZl > div:not(script)').toList();
      for (var element in contentData) {
        content += element.text;
        content += '\n';
      }
      final media = html.querySelectorAll('img._3xXvK');
      for (var element in media) {
        mediaLinks.add(element.attributes['src']);
      }
    } else if (croppedLink.startsWith('foto-haber')) {
      t24Category = 'foto-haber';
      /* bu bölümün ana konusu görseller olmasına rağmen görselleri çekemiyoruz.
      js çalışması gerekiyor istersen daha sonra bunu web view kullanarak yapabilirisn
      şimdilik çalışmıyor olarak idare atmen gerekecek */

      title =
          html.querySelector('div._1YxhA > div._1C396 > div._1VAN- > h1')!.text;
      subtitle =
          html.querySelector('div._1YxhA > div._1C396 > div._1VAN- > h2')?.text;
      date =
          html.querySelector('div._1YxhA > div._1C396 > div._1VAN- > p')!.text;
      final contentData =
          html.querySelectorAll('div._39i_e > div > div > h3').toList();
      for (var element in contentData) {
        content += element.text;
        content += '\n';
      }
    } else if (croppedLink.startsWith('yazarlar')) {
      t24Category = 'yazarlar';

      date = html.querySelector(' div._2PzRZ > div._392lz > p')!.text;
      title = html
          .querySelector('div.col-md-8.col-sm-12.col-xs-12 > div._2teaB > h1')!
          .text;
      subtitle = html
          .querySelector('div.col-md-8.col-sm-12.col-xs-12 > div._2teaB > h2')!
          .text;
      final contentData = html.querySelectorAll(
          'div.col-md-8.col-sm-12.col-xs-12 > div._2teaB > div._1NMxy > div > p');
      for (var element in contentData) {
        content += element.text;
        content += '\n';
      }

      final media = html.querySelectorAll(
          'div.col-md-8.col-sm-12.col-xs-12 > div._2teaB > div._1NMxy > div > h5 > img');
      for (var element in media) {
        mediaLinks.add(element.attributes['src']);
      }
    }
    if (subtitle != null && subtitle.isEmpty) {
      subtitle = null;
    }
    return {
      'date': date,
      'title': title,
      'subtitle': subtitle,
      'content': content.trim(),
      'mediaLinks': mediaLinks,
      'T24Category': t24Category
    };
  }
}
