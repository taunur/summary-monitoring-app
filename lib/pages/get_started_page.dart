import 'package:flutter/material.dart';
import 'package:summary_monitoring/theme.dart';
import 'package:summary_monitoring/widgets/button_default.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({Key? key}) : super(key: key);

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DCS Production',
                  style: textOpenSans.copyWith(
                    color: blackColor,
                    fontSize: 30,
                    fontWeight: extraBold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Warehouse & Delivery',
                  style: textOpenSans.copyWith(
                    color: blackColor.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: semiBold,
                    letterSpacing: 1,
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Image.asset('assets/images/image-started.png'),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        'The best spare part production company with extensive  warehouse storage services and super fast delivery of goods.',
                        textAlign: TextAlign.center,
                        style: textOpenSans.copyWith(
                          color: blackColor.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: regular,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ButtonCustom(
                    title: 'Get Started',
                    press: () {
                      Navigator.pushNamed(context, '/portal');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
