import 'package:flutter/material.dart';

import './condition_save_page.dart';
import './toilet_save_page.dart';
import './setting_page.dart';
import './feedback_page.dart';

class MyPage extends StatefulWidget {
  /*
    bottomNavigationBarのindex=2から遷移するページ．
    個人の設定や保存した情報を確認できる．
  */
  // static values
  static const String route = '/mypage';
  static const String title = 'マイページ';
  // constructor
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

// TODO:UI
class _MyPageState extends State<MyPage> {
// function to go to the next page when press the button
  void _goToNextPage(BuildContext ctx, Widget page) {
    Navigator.of(ctx).push(
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MyPage.title),
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 150,
        padding: const EdgeInsets.all(50),
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _goToNextPage(context, const ConditionSavePage()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Text(ConditionSavePage.title),
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              primary: Colors.white,
              onPrimary: Theme.of(context).colorScheme.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _goToNextPage(context, const ToiletSavePage()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.wc,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Text(ToiletSavePage.title),
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              primary: Colors.white,
              onPrimary: Theme.of(context).colorScheme.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _goToNextPage(context, const SettingPage()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.settings,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Text(SettingPage.title),
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              primary: Colors.white,
              onPrimary: Theme.of(context).colorScheme.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => _goToNextPage(context, const FeedBackPage()),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Icon(
                  Icons.feedback,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const Text(FeedBackPage.title),
              ],
            ),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(10),
              primary: Colors.white,
              onPrimary: Theme.of(context).colorScheme.primary,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
