import 'package:flutter/material.dart';

class ConditionSavePage extends StatefulWidget {
  /*
    TODO:説明
  */
  // static values
  static const String title = '保存した検索条件';
  // constructor
  const ConditionSavePage({Key? key}) : super(key: key);

  @override
  State<ConditionSavePage> createState() => _ConditionSavePageState();
}

class _ConditionSavePageState extends State<ConditionSavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(ConditionSavePage.title),
      ),
      body: const Center(
        child: Text(ConditionSavePage.title),
      ),
    );
  }
}