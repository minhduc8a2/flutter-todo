import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:to_do/pages/loading.dart';
import 'package:to_do/pages/home_page.dart';

late Box box;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        "/": (context) => const Loading(),
        "/home": (context) => const Home(),
      },
      theme: ThemeData(primarySwatch: Colors.yellow),
    );
  }
}
