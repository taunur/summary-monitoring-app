import 'package:flutter/material.dart';
import 'package:summary_monitoring/theme.dart';

class ButtonCustom extends StatelessWidget {
  const ButtonCustom({Key? key, required this.title, required this.press})
      : super(key: key);

  final String title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: press,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: primaryColor,
        ),
        child: Center(
          child: Text(
            title,
            style: textOpenSans.copyWith(
              color: whiteColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ));
  }
}
