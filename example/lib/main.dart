import 'package:flutter/material.dart';
import 'package:pandapie/pandapie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Center(
        child: PandaPie(
          selectedKey: '1',
          data: [
            PandaPieData(
              key: '1',
              value: 10,
            ),
            // PandaPieData(
            //   key: '2',
            //   value: 10,
            // ),
          ],
        ),
      ),
    );
  }
}
