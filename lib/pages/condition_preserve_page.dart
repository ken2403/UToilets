import 'package:flutter/material.dart';

class ConditionPreservePage extends StatefulWidget {
  /*
    TODO:説明
  */
  // static values
  static const String title = '保存した検索条件';
  // constructor
  const ConditionPreservePage({Key? key}) : super(key: key);

  @override
  State<ConditionPreservePage> createState() => _ConditionPreservePageState();
}

class _ConditionPreservePageState extends State<ConditionPreservePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(ConditionPreservePage.title),
      ),
      body: const Center(
        child: Text(ConditionPreservePage.title),
      ),
    );
  }
}
