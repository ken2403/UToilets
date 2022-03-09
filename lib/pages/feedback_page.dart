import 'package:flutter/material.dart';

class FeedBackPage extends StatefulWidget {
  /*
    TODO:説明
  */
  // static values
  static const String title = 'フィードバック';
  // constructor
  const FeedBackPage({Key? key}) : super(key: key);

  @override
  State<FeedBackPage> createState() => _FeedBackPageState();
}

class _FeedBackPageState extends State<FeedBackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(FeedBackPage.title),
      ),
      body: const Center(
        child: Text(FeedBackPage.title),
      ),
    );
  }
}
