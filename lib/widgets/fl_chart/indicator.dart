import 'package:flutter/material.dart';
import 'package:summary_monitoring/theme.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff4F4F4F),
    required this.value,
  }) : super(key: key);
  final Color color;
  final String text;
  final String value;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: isSquare ? BoxShape.rectangle : BoxShape.rectangle,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: textOpenSans.copyWith(
              fontSize: 12,
              fontWeight: regular,
              color: textColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
