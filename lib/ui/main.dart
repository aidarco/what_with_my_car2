import 'package:flutter/material.dart';
import 'nav_bar.dart';
import 'news.dart';
import 'auth.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(appBarTheme: AppBarTheme(backgroundColor: Colors.cyan)),
      routes: {
        "/": (context) => Auth(),
        "/news": (context) => News(),
        "nav_bar": (context) => Nav_bar(),


      },
      initialRoute: "/",
    );
  }
}
