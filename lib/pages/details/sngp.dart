import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:summary_monitoring/constan.dart';
import 'package:summary_monitoring/models/stock_ng_model.dart';
import 'package:http/http.dart' as http;
import 'package:summary_monitoring/theme.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class SumNGPart extends StatefulWidget {
  const SumNGPart({Key? key}) : super(key: key);

  @override
  State<SumNGPart> createState() => _SumNGPartState();
}

class _SumNGPartState extends State<SumNGPart> {
  List<StockNGModel> stock = [];

  TextEditingController tanggal = TextEditingController();
  final String datenow = DateFormat('yyyy-MM-dd').format(DateTime.now());
  List<Color> colors = [
    blueColor,
    purpleColor,
    pinkColor,
    Colors.amber,
    Colors.red,
    Colors.green,
  ];
  bool loading = true;
  void getDataNG() async {
    var response = await http.get(
      Uri.parse(
        baseURL + "/api/stechoq/summary-ngp",
      ),
    );
    List dataStock = json.decode(response.body);
    print(json.decode(response.body));
    // List dataScrap = json.decode(response.body)['scarb_ng'];
    // print(json.decode(response.body));
    setState(() {
      stock = stockModelNGFromJson(dataStock);
      loading = false;
    });
  }

  List<ChartSeries<StockNGModel, String>> _dataChart() {
    return [
      StackedColumnSeries<StockNGModel, String>(
        dataSource: stock,
        color: blueColor,
        xValueMapper: (StockNGModel ch, _) => ch.material,
        yValueMapper: (StockNGModel ch, _) =>
            (ch.scrab_ng.length <= 0) ? 0 : ch.scrab_ng[0].value,
        // (ch.scrab_ng.length < 0) ? 0 : ch.scrab_ng[0].value,
      ),
      StackedColumnSeries<StockNGModel, String>(
        dataSource: stock,
        color: purpleColor,
        xValueMapper: (StockNGModel ch, _) => ch.material,
        yValueMapper: (StockNGModel ch, _) =>
            (ch.scrab_ng.length <= 1) ? 0 : ch.scrab_ng[1].value,
      ),
      StackedColumnSeries<StockNGModel, String>(
        dataSource: stock,
        color: pinkColor,
        xValueMapper: (StockNGModel ch, _) => ch.material,
        yValueMapper: (StockNGModel ch, _) =>
            (ch.scrab_ng.length <= 2) ? 0 : ch.scrab_ng[2].value,
      ),
      StackedColumnSeries<StockNGModel, String>(
        dataSource: stock,
        color: Colors.amber,
        xValueMapper: (StockNGModel ch, _) => ch.material,
        yValueMapper: (StockNGModel ch, _) =>
            (ch.scrab_ng.length <= 3) ? 0 : ch.scrab_ng[3].value,
      ),
      StackedColumnSeries<StockNGModel, String>(
        dataSource: stock,
        color: Colors.red,
        xValueMapper: (StockNGModel ch, _) => ch.material,
        yValueMapper: (StockNGModel ch, _) =>
            (ch.scrab_ng.length <= 4) ? 0 : ch.scrab_ng[4].value,
      ),
      StackedColumnSeries<StockNGModel, String>(
        dataSource: stock,
        color: Colors.green,
        xValueMapper: (StockNGModel ch, _) => ch.material,
        yValueMapper: (StockNGModel ch, _) =>
            (ch.scrab_ng.length <= 5) ? 0 : ch.scrab_ng[5].value,
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    tanggal.text = datenow;
    getDataNG();
  }

  @override
  Widget build(BuildContext context) {
    Widget getChartStackedSummaryNG() {
      return SfCartesianChart(
        plotAreaBackgroundColor: whiteColor,
        plotAreaBorderColor: white2Color,
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: black7Color, fontSize: 8),
          labelRotation: stock.length <= 4 ? 0 : 90,
          isVisible: true,
          isInversed: false,
          plotOffset: 0,
          axisLine: AxisLine(
            color: white2Color,
          ),
        ),
        series: _dataChart(),
      );
    }

    Widget getTableSummaryNG() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: white3Color,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              DataTable(
                border: TableBorder.all(width: 1, color: white3Color),
                dataRowHeight: 72,
                headingRowHeight: 30,
                headingRowColor: MaterialStateColor.resolveWith(
                  (states) => black4Color,
                ),
                columns: <DataColumn>[
                  DataColumn(
                    label: Text(
                      'Material',
                      style: textOpenSans.copyWith(
                        fontSize: 13,
                        fontWeight: regular,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Material Number',
                      style: textOpenSans.copyWith(
                        fontSize: 13,
                        fontWeight: regular,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Scrap NG',
                      style: textOpenSans.copyWith(
                        fontSize: 13,
                        fontWeight: regular,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Quantity Scrab',
                      style: textOpenSans.copyWith(
                        fontSize: 13,
                        fontWeight: regular,
                        color: whiteColor,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Quantity NG',
                      style: textOpenSans.copyWith(
                        fontSize: 13,
                        fontWeight: regular,
                        color: whiteColor,
                      ),
                    ),
                  ),
                ],
                rows: stock
                    .map(
                      (data) => DataRow(
                        cells: [
                          DataCell(
                            Center(
                              child: Text(
                                data.material,
                                style: textOpenSans.copyWith(
                                  fontSize: 15,
                                  fontWeight: regular,
                                  color: black5Color,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                data.material_number,
                                style: textOpenSans.copyWith(
                                  fontSize: 13,
                                  fontWeight: regular,
                                  color: black5Color,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: data.scrab_ng
                                      .map(
                                        (e) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: Text(
                                            e.name,
                                            style: textOpenSans.copyWith(
                                              fontSize: 15,
                                              fontWeight: bold,
                                              color:
                                                  colors.map((e) => e).toList()[
                                                      data.scrab_ng.indexOf(e)],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: data.scrab_ng
                                      .map((e) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
                                            child: Text(
                                              e.value.toString(),
                                              style: textOpenSans.copyWith(
                                                fontSize: 15,
                                                fontWeight: regular,
                                                color: black5Color,
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Center(
                              child: Text(
                                data.getQuantityNG().toString(),
                                style: textOpenSans.copyWith(
                                  fontSize: 15,
                                  fontWeight: regular,
                                  color: black5Color,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Total',
                        style: textOpenSans.copyWith(
                          fontSize: 15,
                          fontWeight: regular,
                          color: black5Color,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width * 0.315,
                    child: Center(
                      child: Text(
                        stock.length == 0
                            ? '0'
                            : stock
                                .map((e) => e.getQuantityNG())
                                .reduce((value, element) => value + element)
                                .toString(),
                        style: textOpenSans.copyWith(
                          fontSize: 15,
                          fontWeight: regular,
                          color: black5Color,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(
            defaultMargin,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.5),
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bar Chart Summary NG Part',
                      style: textOpenSans.copyWith(
                        fontSize: 12,
                        fontWeight: bold,
                        color: black2Color,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        DateTime? pickedDate2 = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate2 != null) {
                          String formattedDate2 =
                              DateFormat('yyyy-MM-dd').format(pickedDate2);
                          print(formattedDate2);
                          setState(
                            () {
                              tanggal.text = formattedDate2;
                            },
                          );
                        } else {
                          print('Date is not selected');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        height: 30,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: white2Color),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 16,
                              color: primaryColor,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              tanggal.text == '' ? 'yyyy-mm-dd' : tanggal.text,
                              style: textOpenSans.copyWith(
                                fontSize: 12,
                                fontWeight: regular,
                                color: blackColor,
                              ),
                            ),
                            Icon(
                              Icons.expand_more,
                              size: 20,
                              color: black3Color,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: white2Color,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              getChartStackedSummaryNG(),
              // Padding(
              //   padding: const EdgeInsets.all(
              //     12,
              //   ),
              //   child: Wrap(
              //     spacing: 8,
              //     runSpacing: 8,
              //     children: stock
              //         .map((e) => Column(
              //               children: [
              //                 Container(
              //                   height: 8,
              //                   width: 20,
              //                   color: colors[stock.indexOf(e)],
              //                 ),
              //                 Text(
              //                   'Data' + stock.indexOf(e).toString(),
              //                 ),
              //                 // Text("Data" + stock.indexOf(e).toString()),
              //               ],
              //             ))
              //         .toList(),
              //     // children: stock
              //     //     .map((data) => Column(
              //     //           children: data.scrab_ng
              //     //               .map(
              //     //                 (e) => Container(
              //     //                   height: 6,
              //     //                   width: 20,
              //     //                   color: colors[stock.indexOf(data)],
              //     //                 ),
              //     //               )
              //     //               .toList(),
              //     //         ))
              //     //     .toList(),
              //     // children: [
              //     //   Column(
              //     //     children: [
              //     //       Container(
              //     //         height: 8,
              //     //         width: 20,
              //     //         color: blueColor,
              //     //       ),
              //     //       SizedBox(
              //     //         height: 4,
              //     //       ),
              //     //       Text(
              //     //         'Data 1',
              //     //         style: textInter.copyWith(
              //     //           fontSize: 10,
              //     //           fontWeight: regular,
              //     //           color: black7Color,
              //     //         ),
              //     //       ),
              //     //     ],
              //     //   ),
              //     //   Column(
              //     //     children: [
              //     //       Container(
              //     //         height: 8,
              //     //         width: 20,
              //     //         color: purpleColor,
              //     //       ),
              //     //       SizedBox(
              //     //         height: 4,
              //     //       ),
              //     //       Text(
              //     //         'Data 2',
              //     //         style: textInter.copyWith(
              //     //           fontSize: 10,
              //     //           fontWeight: regular,
              //     //           color: black7Color,
              //     //         ),
              //     //       ),
              //     //     ],
              //     //   ),
              //     //   Column(
              //     //     children: [
              //     //       Container(
              //     //         height: 8,
              //     //         width: 20,
              //     //         color: pinkColor,
              //     //       ),
              //     //       SizedBox(
              //     //         height: 4,
              //     //       ),
              //     //       Text(
              //     //         'Data 3',
              //     //         style: textInter.copyWith(
              //     //           fontSize: 10,
              //     //           fontWeight: regular,
              //     //           color: black7Color,
              //     //         ),
              //     //       ),
              //     //     ],
              //     //   )
              //     // ],
              //   ),
              // )
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(
            defaultMargin,
          ),
          decoration: BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(
                  0.5,
                ),
                blurRadius: 2,
              )
            ],
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  16,
                ),
                child: Text(
                  'Table No Good Opname',
                  style: textOpenSans.copyWith(
                    fontSize: 12,
                    fontWeight: bold,
                    color: black6Color,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: white2Color,
                      width: 4,
                      style: BorderStyle.solid,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: getTableSummaryNG(),
              ),
              SizedBox(
                height: 12,
              ),
            ],
          ),
        )
      ],
    );
  }
}
