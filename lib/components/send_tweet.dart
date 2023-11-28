import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SendTweet extends StatelessWidget {
  const SendTweet({super.key, required this.url});
  final Uri url;

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.loadRequest(url);
    controller.setNavigationDelegate(NavigationDelegate(
      onProgress: (progress) {
        print(progress);
      },
      onPageFinished: (url) async {
        controller.runJavaScript('''
window.onload = setTimeout(function() {
  document.querySelector("[data-testid='tweetButton']").click();
  
}, 2000);''');
      },
    ));
    return SafeArea(child: WebViewWidget(controller: controller));
  }
}
