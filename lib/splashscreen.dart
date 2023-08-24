import 'dart:async';
import 'package:flutter/material.dart';
import 'package:summary_monitoring/pages/home_page.dart';

import 'helper/user_info.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  splashscreenStart() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      // Navigator.pushNamed(context, '/get-started');
      setState(() {
        loadUserInfo();
      });
    });
  }

  void loadUserInfo() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    String token = await getToken();
    if (token == '') {
      Navigator.pushNamed(context, '/get-started');
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    splashscreenStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/frametop.png'),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo-dcs.png',
                  width: 265,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Image.asset('assets/images/framebottom.png'),
            ),
          ]),
        ),
      ),
    );
  }
}
