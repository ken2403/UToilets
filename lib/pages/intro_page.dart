import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:permission_handler/permission_handler.dart';

import './homepage.dart';

class IntroPage extends StatefulWidget {
  /*
    初回起動時のみ表示されるページ．
    初期設定(性別と位置情報の許可)と簡単なアプリの説明を行う．
  */
  // constructor
  const IntroPage({
    Key? key,
    required this.chosenSex,
    required this.selectedSexRadio,
    required this.onIntroEnd,
  }) : super(key: key);
  final ChosenSex chosenSex;
  final void Function(Object?) selectedSexRadio;
  final void Function() onIntroEnd;

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  // set some constants
  final radioText = <ChosenSex, String>{
    ChosenSex.male: '男性',
    ChosenSex.female: '女性',
  };
  final introKey = GlobalKey<IntroductionScreenState>();

  // footer for skip intro
  Widget _skipButton(String _message) {
    return TextButton(
      child: Text(
        _message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontSize: Theme.of(context).textTheme.button!.fontSize,
          fontWeight: Theme.of(context).textTheme.button!.fontWeight,
        ),
      ),
      onPressed: widget.onIntroEnd,
    );
  }

  @override
  Widget build(BuildContext context) {
    // set constants for style
    final TextStyle bodyStyle = Theme.of(context).textTheme.bodyText1!;
    final PageDecoration pageDecoration = PageDecoration(
      pageColor: Colors.white,
      titleTextStyle: Theme.of(context).textTheme.headline5!,
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      imagePadding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
      footerPadding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 0.0),
      fullScreen: false,
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.center,
    );
    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      globalHeader: Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 16, right: 16),
            child: Text(
              "UToilets",
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "アプリの利用設定",
          image: Image.asset('assets/images/splash.png', width: 350),
          bodyWidget: Column(
            children: <Widget>[
              Text(
                "トイレを利用する際の\n性別を設定してください",
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio(
                    value: ChosenSex.male,
                    groupValue: widget.chosenSex,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) => widget.selectedSexRadio(value),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 15),
                    child: Text(radioText[ChosenSex.male]!),
                  ),
                  Radio(
                    value: ChosenSex.female,
                    groupValue: widget.chosenSex,
                    activeColor: Theme.of(context).colorScheme.primary,
                    onChanged: (value) => widget.selectedSexRadio(value),
                  ),
                  Container(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(radioText[ChosenSex.female]!),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30, 0),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () async {
                      var status =
                          await Permission.accessMediaLocation.request();
                      // 権限がない場合の処理.
                      if (status.isDenied ||
                          status.isRestricted ||
                          status.isPermanentlyDenied) {
                        // 端末の設定画面へ遷移.
                        await openAppSettings();
                      }
                    },
                    child: Text(
                      "位置情報の利用を設定する",
                      style: Theme.of(context).textTheme.button,
                    ),
                  ),
                ),
              ),
            ],
          ),
          decoration: pageDecoration.copyWith(),
        ),
        PageViewModel(
          title: "緊急性が高いとき",
          body: "急いでいるときは画面中央下の地図ボタンを選択して最寄りのトイレへGO!",
          reverse: false,
          footer: _skipButton('今すぐアプリを使う'),
          decoration: pageDecoration.copyWith(),
        ),
        PageViewModel(
          title: "お気に入りのトイレを探す",
          body: "条件を設定してお気に入りのトイレを探そう！",
          reverse: false,
          footer: _skipButton('今すぐアプリを使う'),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
          ),
        ),
        PageViewModel(
          title: "快適なトイレライフを！",
          bodyWidget: Container(),
          decoration: pageDecoration.copyWith(
            bodyFlex: 2,
            imageFlex: 4,
          ),
          footer: _skipButton('アプリを使う'),
        ),
      ],
      onDone: widget.onIntroEnd,
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: Icon(
        Icons.arrow_back,
        color: Theme.of(context).colorScheme.primary,
      ),
      next: Icon(
        Icons.arrow_forward,
        color: Theme.of(context).colorScheme.primary,
      ),
      done: Text(
        'Done',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: DotsDecorator(
        size: const Size(10.0, 10.0),
        color: Theme.of(context).colorScheme.background,
        activeSize: const Size(20.0, 10.0),
        activeColor: Theme.of(context).colorScheme.primary,
        activeShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
      ),
    );
  }
}
