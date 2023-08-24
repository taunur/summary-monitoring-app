import 'package:flutter/material.dart';
import 'package:summary_monitoring/list/pie_data.dart';
import 'package:summary_monitoring/theme.dart';

class IndicatorsWidget extends StatelessWidget {
  const IndicatorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: PieData.data.map((data) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: buildIndicator(
            color: data.color,
            text: data.name, value: data.value,
            // isSquare: true,
          ),
        );
      }).toList(),
    );
  }

  Widget buildIndicator({
    required Color color,
    required String text,
    required int value,
    bool isSquare = false,
    double size = 16,
  }) {
    return Row(
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
          "$value Kg",
          style: textOpenSans.copyWith(
            fontSize: 14,
            fontWeight: regular,
            color: blackColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: textOpenSans.copyWith(
            fontSize: 14,
            fontWeight: bold,
            color: blackColor,
          ),
        ),
      ],
    );
  }
}
