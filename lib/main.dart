import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 50.0,
            ),
            Text(
              "Hi, I'm Dongwook Min",
              style: TextStyle(fontSize: 56.0),
            ),
            Text(
              'This page was made with Flutter!',
              style: TextStyle(fontSize: 28.0),
            )
          ],
        ),
      )),
    );
  }
}
