import 'package:auto_tweet/components/send_tweet.dart';
import 'package:auto_tweet/gdocs.dart';
import 'package:flutter/material.dart';

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
              showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(Duration(seconds: 20), () {
                    Navigator.pop(context);
                  });
                  return SendTweet(
                      url: Uri.parse(
                          '''https://twitter.com/compose/tweet?&text=Merhaba %23dünya bununla beraber tweet ortasında hashtag meselesini çözmüş oldum.'''));
                },
              );
            },
            child: const Text(
              'send tweet',
              style: TextStyle(color: Colors.brown),
            )),
      ),
    );
  }
}
