import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class _SendTweet extends StatelessWidget {
  const _SendTweet({required this.url});
  final Uri url;

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(url);
    controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (url) async {
        controller.runJavaScript('''
window.onload = setTimeout(function() {
  document.querySelector("[data-testid='tweetButton']").click();
  
}, 4000);''');
      },
    ));
    return SafeArea(child: WebViewWidget(controller: controller));
  }
}

Widget loginTwitter() {
  return _SendTweet(url: Uri.parse("https://twitter.com/"));
}

void sendTweet({required String tweetText, required BuildContext context}) {
  showDialog(
    context: context,
    builder: (context) {
      Future.delayed(const Duration(seconds: 30), () {
        Navigator.pop(context);
      });
      return _SendTweet(
          url: Uri.parse(
              '''https://twitter.com/compose/tweet?&text=${Uri.encodeQueryComponent(tweetText)}'''));
    },
  );
}

/* Merhaba %23dünya bununla beraber tweet ortasında hashtag meselesini çözmüş oldum. */