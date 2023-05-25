// import 'dart:io' show Platform;
import 'package:flutter/material.dart';
// import 'package:gpt2338/widgets/web_view_page.dart';
import 'package:gpt2338/widgets/in_app_web_view_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPT 2338',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const InAppWebViewPage(),
      // home: const WebViewPage(),
    );
  }
}
