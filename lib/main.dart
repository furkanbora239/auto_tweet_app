import 'package:auto_tweet/gdocs.dart';
import 'package:auto_tweet/tweet_system.dart';
import 'package:flutter/material.dart';

void main() async {
  await GSheetsApi().init();
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TweetSystem().auto(context: context);
    return const ColoredBox(color: Colors.black);
  }
}
