import 'package:flutter/material.dart';
import 'package:summary_monitoring/theme.dart';

// ignore_for_file: must_be_immutable
class SuplierCard extends StatelessWidget {
  String namaSupllier;
  String descriptionSupllier;
  String logoSupllier;
  VoidCallback press;
  SuplierCard({
    Key? key,
    required this.namaSupllier,
    required this.descriptionSupllier,
    required this.logoSupllier,
    required this.press,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 10,
      ),
      child: GestureDetector(
        onTap: press,
        child: Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
            15,
          )),
          color: whiteColor,
          child: Container(
            padding: const EdgeInsets.all(
              12,
            ),
            child: Row(
              children: [
                Image.asset(
                  logoSupllier,
                  width: 44,
                  height: 49,
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        namaSupllier,
                        style: textOpenSans.copyWith(
                          color: blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        descriptionSupllier,
                        style: textOpenSans.copyWith(
                          color: blackColor,
                          fontSize: 9,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
