import 'package:flutter/material.dart';

class ToiletPreservePage extends StatefulWidget {
  /*
    TODO:説明
  */
  // static values
  static const String title = '保存したトイレ';
  // constructor
  const ToiletPreservePage({Key? key}) : super(key: key);

  @override
  State<ToiletPreservePage> createState() => _ToiletPreservePageState();
}

class _ToiletPreservePageState extends State<ToiletPreservePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(ToiletPreservePage.title),
      ),
      body: const Center(
        child: Text(ToiletPreservePage.title),
      ),
    );
  }
}
