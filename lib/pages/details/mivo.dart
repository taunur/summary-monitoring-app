import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:summary_monitoring/models/mivo_model.dart';
import 'package:summary_monitoring/models/rak_model.dart';
import 'package:summary_monitoring/services/mivo_service.dart';
import 'package:summary_monitoring/services/monrak_service.dart';
import 'package:summary_monitoring/theme.dart';
import 'package:summary_monitoring/widgets/dashline.dart';
import 'package:summary_monitoring/widgets/fl_chart/indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../helper/user_info.dart';

class MaterialInVSOut extends StatefulWidget {
  const MaterialInVSOut({Key? key}) : super(key: key);

  @override
  State<MaterialInVSOut> createState() => _MaterialInVSOutState();
}

class _MaterialInVSOutState extends State<MaterialInVSOut> {
  int touchedIndex = -1;
  bool loading = true;
  DateTime? _dateTime;
  late List<DataMivo> _dataMivo;
  late List<DataRak> _dataRak;
  double size = 22;

  final List<String> itemsRak = [
    'M',
    'B',
  ];

  final List<String> itemsAdress = [
    'A1.01.01',
    'A2.01.01',
  ];

  final List<String> itemsMaterial = [
    "1",
    "2",
  ];

  String? pilihAdress;
  String? pilihRak;
  String? pilihMaterial;

  @override
  void initState() {
    _dataRak = [];
    _getMonRak();
    _dataMivo = [];
    pilihAdress = "A1.01.01";
    pilihMaterial = '1';
    pilihRak = 'M';
    _getDataMivo();
    _getAdress();
    super.initState();
  }

  _getDataMivo() async {
    String token = await getToken();
    _dataMivo = await ServiceMivo.getDataMivo(token, pilihMaterial.toString());
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  _getMonRak() async {
    String token = await getToken();
    _dataRak = await ServiceMonrak.getMonRak(token, pilihRak.toString());
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  _getAdress() async {
    String token = await getToken();
    _dataRak = await ServiceMonrak.getAddress(token, pilihAdress.toString());
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  List<charts.Series<DataRak, String>> _createSampleData() {
    return List<charts.Series<DataRak, String>>.generate(
      6,
      (index) {
        return charts.Series<DataRak, String>(
          data: _dataRak,
          id: 'id',
          seriesColor: charts.ColorUtil.fromDartColor(primaryColor),
          domainFn: (DataRak dataRak, _) {
            return dataRak.supplier[index].namaSupplier;
          },
          measureFn: (DataRak dataRak, _) => dataRak.supplier[index].jumlah,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            // Pie chart Material
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: loading
                  ? SizedBox(
                      height: 400,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Pie Chart",
                                  style: textOpenSans.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  height: 30,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 206, 213, 222),
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 6),
                                    child: DropdownButton(
                                      underline: const SizedBox(),
                                      icon: const Icon(
                                        CupertinoIcons.chevron_down,
                                        size: 16,
                                      ),
                                      hint: const Text('Select Material'),
                                      items: itemsMaterial
                                          .map((item) =>
                                              DropdownMenuItem<String>(
                                                value: item,
                                                child: item == "1"
                                                    ? const Text("Material")
                                                    : const Text(
                                                        "Batch Material"),
                                              ))
                                          .toList(),
                                      style: textOpenSans.copyWith(
                                        color: const Color(0xff7E7E7E),
                                        fontSize: 12,
                                        fontWeight: regular,
                                      ),
                                      elevation: 0,
                                      dropdownColor: whiteColor,
                                      onChanged: (newVal) {
                                        setState(() {
                                          pilihMaterial = newVal as String;
                                          print(newVal);
                                          _getDataMivo();
                                        });
                                      },
                                      value: pilihMaterial,
                                    ),
                                  ),
                                ),
                                // Material(
                                //   child: InkWell(
                                //     onTap: () {
                                //       showDialog(
                                //           context: context,
                                //           builder: (BuildContext context) {
                                //             return AlertDialog(
                                //               title:
                                //                   const Text("Select Material"),
                                //               content: SizedBox(
                                //                 height: 60.0,
                                //                 width: 100.0,
                                //                 child: SimpleDialogOption(
                                //                   child: ListView.builder(
                                //                       shrinkWrap: true,
                                //                       itemCount: _dataMivo.length,
                                //                       itemBuilder:
                                //                           (context, index) {
                                //                         return InkWell(
                                //                           onTap: () {
                                //                             Navigator.pop(
                                //                                 context);
                                //                             _getDataMivo();
                                //                           },
                                //                           child: Padding(
                                //                             padding:
                                //                                 const EdgeInsets
                                //                                     .only(top: 2),
                                //                             child: Text(
                                //                               _dataMivo[index]
                                //                                   .material
                                //                                   .toUpperCase(),
                                //                               style: textOpenSans
                                //                                   .copyWith(
                                //                                 fontWeight:
                                //                                     regular,
                                //                                 fontSize: 14,
                                //                               ),
                                //                             ),
                                //                           ),
                                //                         );
                                //                       }),
                                //                 ),
                                //               ),
                                //               contentPadding: EdgeInsets.zero,
                                //               actionsPadding:
                                //                   MediaQuery.of(context)
                                //                       .padding
                                //                       .copyWith(
                                //                         left: 0,
                                //                         right: 10,
                                //                         top: 0,
                                //                         bottom: 10,
                                //                       ),
                                //               actions: [
                                //                 ElevatedButton(
                                //                   onPressed: () {
                                //                     Navigator.pop(context);
                                //                   },
                                //                   child: const Text("Cancel"),
                                //                 )
                                //               ],
                                //             );
                                //           });
                                //     },
                                //     child: Text(
                                //       "Pie Chart",
                                //       style: textOpenSans.copyWith(
                                //         fontSize: 14,
                                //         fontWeight: bold,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(width: 8),
                                InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime(2021),
                                      firstDate: DateTime(2021),
                                      lastDate: DateTime.now(),
                                    ).then((date) {
                                      setState(() {
                                        _dateTime = date;
                                        print(_dateTime);
                                      });
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    width: 145,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: primaryColor),
                                      color: whiteColor,
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_month,
                                            color: primaryColor,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _dateTime == null
                                                ? DateFormat("yMd", "id")
                                                    .format(DateTime.now())
                                                : DateFormat("yMd", "id")
                                                    .format(_dateTime!),
                                            style: textOpenSans.copyWith(
                                              fontWeight: regular,
                                            ),
                                          ),
                                          const Icon(
                                            CupertinoIcons.chevron_down,
                                            color: Colors.black87,
                                            size: 17,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: DashLineView(
                            fillRate: 1,
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: PieChart(
                                  PieChartData(
                                    pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event,
                                          pieTouchResponse) {
                                        setState(() {
                                          if (!event
                                                  .isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection ==
                                                  null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!
                                              .touchedSectionIndex;
                                        });
                                      },
                                    ),
                                    borderData: FlBorderData(
                                      show: false,
                                    ),
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 0,
                                    sections: showingSections(touchedIndex),
                                  ),
                                  swapAnimationDuration: const Duration(
                                      milliseconds: 150), // Optional
                                  swapAnimationCurve: Curves.linear,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 200,
                              width: 200,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Indicator(
                                          color: const Color(0xff63E758),
                                          value:
                                              "${_dataMivo.isNotEmpty ? _dataMivo[index].totalIn : 0} Kg",
                                          text: 'In',
                                          isSquare: false,
                                          size: touchedIndex == 0 ? 18 : 16,
                                          textColor: touchedIndex == 0
                                              ? Colors.black
                                              : blackColor,
                                        ),
                                        Indicator(
                                          color: const Color(0xff165BAA),
                                          value:
                                              '${_dataMivo.isNotEmpty ? _dataMivo[index].totalOut : 0} Kg',
                                          text: 'Out',
                                          isSquare: false,
                                          size: touchedIndex == 1 ? 18 : 16,
                                          textColor: touchedIndex == 1
                                              ? Colors.black
                                              : blackColor,
                                        ),
                                        Indicator(
                                          color: const Color(0xffF765A3),
                                          value:
                                              '${_dataMivo.isNotEmpty ? _dataMivo[index].totalStock : 0} Kg',
                                          text: 'Stock',
                                          isSquare: false,
                                          size: touchedIndex == 2 ? 18 : 16,
                                          textColor: touchedIndex == 2
                                              ? Colors.black
                                              : blackColor,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 28,
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            // Chart Monitoring Rak
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: loading
                  ? SizedBox(
                      height: 400,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Text(
                                  "Chart Monitoring Rak",
                                  style: textOpenSans.copyWith(
                                    fontSize: 14,
                                    fontWeight: bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 206, 213, 222),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: DropdownButton(
                                          underline: const SizedBox(),
                                          icon: const Icon(
                                            CupertinoIcons.chevron_down,
                                            size: 16,
                                          ),
                                          hint: const Text('Select Rak'),
                                          items: itemsRak
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text("Rak " + item),
                                                  ))
                                              .toList(),
                                          style: textOpenSans.copyWith(
                                            color: const Color(0xff7E7E7E),
                                            fontSize: 12,
                                            fontWeight: regular,
                                          ),
                                          elevation: 0,
                                          dropdownColor: whiteColor,
                                          onChanged: (newVal) {
                                            setState(() {
                                              pilihRak = newVal as String;
                                              print(newVal);
                                              _getMonRak();
                                            });
                                          },
                                          value: pilihRak,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      height: 30,
                                      width: 80,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 206, 213, 222),
                                              width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 6),
                                        child: DropdownButton(
                                          underline: const SizedBox(),
                                          icon: const Icon(
                                            CupertinoIcons.chevron_down,
                                            size: 16,
                                          ),
                                          items: itemsAdress
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                    ),
                                                  ))
                                              .toList(),
                                          hint: const Text('Adrees'),
                                          style: textOpenSans.copyWith(
                                            color: const Color(0xff7E7E7E),
                                            fontSize: 12,
                                            fontWeight: regular,
                                          ),
                                          elevation: 0,
                                          dropdownColor: whiteColor,
                                          onChanged: (newVal) {
                                            setState(() {
                                              pilihAdress = newVal.toString();
                                              print(newVal);
                                              _getAdress();
                                            });
                                          },
                                          value: pilihAdress,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: DashLineView(
                            fillRate: 1,
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1,
                          child: Column(
                            children: [
                              Expanded(
                                child: charts.BarChart(
                                  _createSampleData(),
                                  animate: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 16,
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                ),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    itemBuilder: ((context, index) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: size,
                                            height: size,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xff5E72E4),
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Used",
                                                style: textOpenSans.copyWith(
                                                  fontWeight: semiBold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                "${_dataMivo.isNotEmpty ? _dataRak[index].used.toString() : 0} Kg",
                                                style: textOpenSans.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: regular,
                                                  color: blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            width: size,
                                            height: size,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xff63E758),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Available",
                                                style: textOpenSans.copyWith(
                                                  fontWeight: semiBold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                _dataMivo.isNotEmpty
                                                    ? _dataRak[index]
                                                        .available
                                                        .toString()
                                                    : 0.toString(),
                                                style: textOpenSans.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: regular,
                                                  color: blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            width: size,
                                            height: size,
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffFB6340),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Supplier",
                                                style: textOpenSans.copyWith(
                                                  fontWeight: semiBold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                _dataMivo.isNotEmpty
                                                    ? _dataRak[index]
                                                        .totalSupplier
                                                        .toString()
                                                    : 0.toString(),
                                                style: textOpenSans.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: regular,
                                                  color: blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    })),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections(int touchedIndex) {
    return List.generate(
      3,
      (i) {
        final isTouched = i == touchedIndex;
        // final opacity = isTouched ? 1.0 : 0.6;
        final double fontSize = isTouched ? 24 : 12;
        final double radius = isTouched ? 80 : 60;

        const color0 = Color(0xff63E758);
        const color1 = Color(0xff165BAA);
        const color2 = Color(0xffF765A3);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value:
                  _dataMivo.isNotEmpty ? _dataMivo[0].totalOut.toDouble() : 0,
              title: _dataMivo.isNotEmpty
                  ? _dataMivo[0].totalOut.toString()
                  : 0.toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
              titlePositionPercentageOffset: 0.55,
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: _dataMivo.isNotEmpty ? _dataMivo[0].totalIn.toDouble() : 0,
              title: _dataMivo.isNotEmpty
                  ? _dataMivo[0].totalIn.toString()
                  : toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
              titlePositionPercentageOffset: 0.55,
            );
          case 2:
            return PieChartSectionData(
              // color: color2.withOpacity(opacity),
              color: color2,
              value:
                  _dataMivo.isNotEmpty ? _dataMivo[0].totalStock.toDouble() : 0,
              title: _dataMivo.isNotEmpty
                  ? _dataMivo[0].totalStock.toString()
                  : 0.toString(),
              radius: radius,
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: whiteColor,
              ),
              titlePositionPercentageOffset: 0.6,
            );
          default:
            throw Exception('Error Pie Chart');
        }
      },
    );
  }
}
