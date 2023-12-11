import 'package:auto_tweet/tweet_system.dart';
import 'package:auto_tweet/update_widget.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MaterialApp(
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TweetSystem().auto(context: context);
    return ColoredBox(
      color: Colors.black,
      child: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Expanded(
              child: StreamBuilder<List<String>>(
                  initialData: StringStream().console,
                  stream: StringStream().eventStream,
                  builder: (context, snapshot) {
                    return Row(
                      verticalDirection: VerticalDirection.up,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        for (int i = 0; i < StringStream().console.length; i++)
                          Text(snapshot.data![i])
                      ],
                    );
                  })),
        )),
      ),
    );
  }
}
