import 'package:call_check/call_status.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ).copyWith(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Example(),
        // body: HomePage(),
      ),
    );
  }
}
