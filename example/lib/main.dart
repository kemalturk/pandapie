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
      debugShowCheckedModeBanner: false,
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
      backgroundColor: Color(0xFF202327),
      body: Center(
        child: PandaPie(
          selectedKey: '3',
          data: [
            PandaPieData(
              key: '1',
              value: 50,
            ),
            PandaPieData(
              key: '2',
              value: 50,
            ),
            PandaPieData(
              key: '3',
              value: 30,
            ),
          ],
        ),
      ),
    );
  }
}
