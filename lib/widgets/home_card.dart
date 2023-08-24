import 'package:flutter/material.dart';
import 'package:summary_monitoring/models/homepage_tile.dart';
import 'package:summary_monitoring/theme.dart';

class BodyHome extends StatelessWidget {
  final ListBodyHome listBodyHome;
  final VoidCallback tap;
  const BodyHome({Key? key, required this.listBodyHome, required this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              Expanded(
                child: Text(
                  listBodyHome.title,
                  style: blackTextStyle.copyWith(
                    fontWeight: semiBold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Image.asset(
                  listBodyHome.image,
                  width: 90,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
