import 'package:flutter/material.dart';

// Local
import 'package:veil/pages/home.dart';

// Styles
import 'package:veil/styles/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'veil',

      theme: ThemeData(
        primarySwatch: CustomStyle.pageSwatch,
        colorScheme: CustomStyle.pageScheme,
        appBarTheme: CustomStyle.appBarTheme,
        textSelectionTheme: CustomStyle.pageTextSelectionTheme,
      ),

      home: const HomePage(title: 'Veil'),
    );
  }
}


