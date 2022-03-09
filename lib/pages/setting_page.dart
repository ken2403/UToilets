import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  /*
    TODO:説明
  */
  // static values
  static const String title = '設定';
  // constructor
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(SettingPage.title),
      ),
      body: const Center(
        child: Text(SettingPage.title),
      ),
    );
  }
}
