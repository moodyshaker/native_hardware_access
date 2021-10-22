import 'package:flutter/material.dart';

import 'screen/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Native Code',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Home.id,
      routes: {
        Home.id: (_) => const Home(),
      },
    );
  }
}
