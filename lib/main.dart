import 'package:flutter/material.dart';

import './pages/homepage.dart';

void main() {
  runApp(const UToilet());
}

class UToilet extends StatefulWidget {
  const UToilet({Key? key}) : super(key: key);

  @override
  State<UToilet> createState() => _UToiletState();
}

class _UToiletState extends State<UToilet> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Search available toilet',
      home: const HomePage(),
      theme: ThemeData(
        unselectedWidgetColor: Colors.black54,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.lightBlue,
        ).copyWith(
          primary: Colors.lightBlue,
          secondary: Colors.lightGreen,
          background: Colors.black87.withAlpha(100),
          surface: Colors.white,
        ),
        canvasColor: const Color.fromRGBO(255, 254, 249, 1),
        fontFamily: 'ARIAL',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headline5: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              bodyText1: const TextStyle(
                fontSize: 18,
                color: Colors.black87,
              ),
              bodyText2: const TextStyle(
                fontSize: 15,
                color: Colors.black54,
              ),
              button: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
      ),
    );
  }
}
