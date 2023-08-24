import 'package:flutter/material.dart';

class PieData {
  static List<Data> data = [
    Data(
      name: 'In',
      value: 40,
      color: const Color(0xff165BAA),
    ),
    Data(
      name: 'Out',
      value: 30,
      color: const Color(0xffF765A3),
    ),
    Data(
      name: 'Stock',
      value: 15,
      color: const Color(0xff16BFD6),
    ),
  ];
}

class Data {
  final String name;
  final int value;
  final Color color;
  Data({
    required this.name,
    required this.value,
    required this.color,
  });
}
