import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted);
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    controller.loadRequest(Uri.parse('https://x.com/'));
    return SafeArea(child: WebViewWidget(controller: controller));
  }
}
