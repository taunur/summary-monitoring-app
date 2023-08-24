import 'package:flutter/material.dart';

import 'pages/details/sngp.dart';
import 'pages/get_started_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/portal_page.dart';
import 'splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/splashscreen': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/get-started': (context) => const GetStartedPage(),
        '/portal': (context) => const PortalPage(),
        '/home': (context) => const HomePage(),
        // '/detail-home': (context) => const DetailHomePage(),
        '/detail-stock-ng': (context) => const SumNGPart(),
      },
    );
  }
}
