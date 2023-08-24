import 'dart:convert';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:summary_monitoring/models/plan_actual_modal.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import '../../theme.dart';

class SumDailyProdAchiev extends StatefulWidget {
  const SumDailyProdAchiev({Key? key}) : super(key: key);

  @override
  State<SumDailyProdAchiev> createState() => _SumDailyProdAchievState();
}

class _SumDailyProdAchievState extends State<SumDailyProdAchiev> {
  TextEditingController tanggal = TextEditingController();
  final String datenow = DateFormat('dd/MM/yyyy').format(DateTime.now());
  bool loading = true;
  List percentageList = [];
  List<PLanActualModel> planned = [];
  List<PLanActualModel> achieved = [];
  List<PLanActualModel> gap = [];
  String total = '';

  void getData() async {
    var response = await http.get(
      Uri.parse(
        "https://638c9d1beafd555746aa50c9.mockapi.io/percentage",
      ),
    );
    var data = json.decode(response.body)['data'];
    setState(() {
      // total = data
      percentageList = data;
      loading = false;
    });
  }

  void getPlan() async {
    var response = await http.get(
      Uri.parse(
        "https://6391f112b750c8d178d23df5.mockapi.io/api/plan-actual",
      ),
    );
    var planneds = json.decode(response.body)['data']['planned'];
    var achieveds = json.decode(response.body)['data']['achieved'];
    var gaps = json.decode(response.body)['data']['gap'];
    setState(() {
      planned = planActualModelFromJson(planneds);
      achieved = planActualModelFromJson(achieveds);
      gap = planActualModelFromJson(gaps);
      loading = false;
    });
  }

  List<charts.Series<PLanActualModel, String>> _createSampleData() {
    return [
      charts.Series<PLanActualModel, String>(
        id: 'planned',
        domainFn: (PLanActualModel testModel, _) => testModel.name,
        measureFn: (PLanActualModel testModel, _) => testModel.value,
        seriesColor: charts.ColorUtil.fromDartColor(const Color(0xff376ED9)),
        data: planned,
      ),
      charts.Series<PLanActualModel, String>(
        id: 'gap',
        domainFn: (PLanActualModel testModel, _) => testModel.name.toString(),
        measureFn: (PLanActualModel testModel, _) => testModel.value,
        seriesColor: charts.ColorUtil.fromDartColor(const Color(0xffE94D4D)),
        data: gap,
      ),
      charts.Series<PLanActualModel, String>(
        id: 'achieved',
        domainFn: (PLanActualModel testModel, _) => testModel.name,
        measureFn: (PLanActualModel testModel, _) => testModel.value,
        seriesColor: charts.ColorUtil.fromDartColor(const Color(0xff219653)),
        data: achieved,
      )
    ];
  }

  void initState() {
    super.initState();
    tanggal.text = datenow;
    getData();
    getPlan();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 400,
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Plan vs Actual",
                            style: textOpenSans.copyWith(
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () async {
                              DateTime? pickedDate2 = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101));

                              if (pickedDate2 != null) {
                                String formattedDate2 = DateFormat('dd/MM/yyyy')
                                    .format(pickedDate2);
                                print(formattedDate2);

                                setState(() {
                                  tanggal.text = formattedDate2;
                                });
                              } else {
                                print("Date is not selected");
                              }
                            },
                            child: Container(
                              height: 40,
                              width: 140,
                              decoration: BoxDecoration(
                                  border: Border.all(color: primaryColor),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                      child: Icon(
                                        Icons.calendar_month,
                                        color: primaryColor,
                                      ),
                                    ),
                                    Text(
                                      tanggal.text == ''
                                          ? 'dd/mm/yyy'
                                          : tanggal.text,
                                      style: TextStyle(
                                        color: black2Color,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(188, 158, 158, 158),
                      height: 1,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: charts.BarChart(
                          _createSampleData(),
                          animate: true,
                          barGroupingType: charts.BarGroupingType.stacked,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              height: 400,
              child: Card(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Achievement Percentage",
                        style: textOpenSans.copyWith(
                          color: blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(188, 158, 158, 158),
                      height: 1,
                    ),
                    Expanded(
                        child: Stack(
                      children: [
                        DChartPie(
                          data: percentageList.map((e) {
                            return {'domain': e['name'], 'measure': e['value']};
                          }).toList(),
                          fillColor: ((pieData, index) {
                            switch (index) {
                              case 0:
                                return const Color(0xff219653);
                              case 1:
                                return const Color(0xffE94D4D);
                              default:
                            }
                          }),
                          donutWidth: 60,
                          labelColor: Colors.white,
                        ),
                        Center(
                          child: Text(
                            'Total',
                            style: textOpenSans.copyWith(
                              color: blackColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                            ),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
