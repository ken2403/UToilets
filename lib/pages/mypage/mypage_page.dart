import 'package:flutter/material.dart';

import '../../widgets/appbar.dart';
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
  static const String route = '/home/mypage';
  static const String title = 'マイページ';
  // constructor
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

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

  // function of elevated button
  Widget _customElevatedButton(Widget page, IconData icon, String title) {
    return ElevatedButton(
      onPressed: () => _goToNextPage(context, page),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Icon(
            icon,
            size: 30,
            color: Theme.of(context).unselectedWidgetColor,
          ),
          Text(
            title,
            style: TextStyle(
              color: Theme.of(context).unselectedWidgetColor,
              fontSize: 14,
            ),
          ),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, MyPage.title),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 30),
        child: GridView.extent(
          maxCrossAxisExtent: 150,
          mainAxisSpacing: 25,
          crossAxisSpacing: 25,
          children: <Widget>[
            _customElevatedButton(const ConditionSavePage(), Icons.search,
                ConditionSavePage.title),
            _customElevatedButton(
                const ToiletSavePage(), Icons.wc, ToiletSavePage.title),
            _customElevatedButton(
                const SettingPage(), Icons.settings, SettingPage.title),
            _customElevatedButton(
                const FeedBackPage(), Icons.feed, FeedBackPage.title),
          ],
        ),
      ),
    );
  }
}
