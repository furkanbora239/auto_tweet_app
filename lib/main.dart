import 'package:auto_tweet/tweet_system.dart';
import 'package:auto_tweet/update_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

int test = 0;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TweetSystem().auto(context: context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: ValueListenableBuilder(
        valueListenable: Terminal.console,
        builder: (context, value, child) {
          return SingleChildScrollView(
            reverse: true,
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < value.length; i++)
                  Text(
                    value[i],
                    style: const TextStyle(color: Colors.white),
                  )
              ],
            ),
          );
        },
      )),
    );
  }
}
