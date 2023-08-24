import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:summary_monitoring/helper/user_info.dart';
import 'package:summary_monitoring/models/pfgivo_model.dart';
import 'package:summary_monitoring/services/pfgivo_service.dart';
import 'package:summary_monitoring/theme.dart';
import 'package:summary_monitoring/widgets/dashline.dart';

import 'package:pie_chart/pie_chart.dart';

class ProdFGInVSOut extends StatefulWidget {
  const ProdFGInVSOut({Key? key}) : super(key: key);

  @override
  State<ProdFGInVSOut> createState() => _ProdFGInVSOutState();
}

class _ProdFGInVSOutState extends State<ProdFGInVSOut> {
  DateTime? _dateTime;
  int touchedIndex = -1;
  // List<DataPfgivo> dataList = []; // list of api data
  late List<DataPfgivo> _dataPfgivo;
  bool loading = true;

  // this will make state when app runs
  @override
  void initState() {
    _dataPfgivo = [];
    _getPfgivo();
    super.initState();
  }

  _getPfgivo() async {
    String token = await getToken();
    _dataPfgivo = await ServicePfgivo.getData(token);
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('id', null);
    // this is a map of data bacause piechart need a map
    Map<String, double> dataMap = {
      "in": _dataPfgivo.isNotEmpty ? _dataPfgivo[0].stockin.toDouble() : 0,
      "out": _dataPfgivo.isNotEmpty ? _dataPfgivo[0].stockout.toDouble() : 0,
      "stock":
          _dataPfgivo.isNotEmpty ? _dataPfgivo[0].totalstock.toDouble() : 0,
    };
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pie Production FG In Vs Out",
                                style: textOpenSans.copyWith(
                                  fontSize: 14,
                                  fontWeight: bold,
                                ),
                              ),
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
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  height: 36,
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
                        const DashLineView(
                          fillRate: 1,
                        ),
                        Row(
                          children: [
                            const SizedBox(
                              height: 18,
                            ),
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.6,
                                child: PieChart(
                                  dataMap:
                                      dataMap, // this need to be map for piechart
                                  animationDuration:
                                      const Duration(milliseconds: 800),
                                  chartLegendSpacing: 32,
                                  initialAngleInDegree: 0,
                                  chartType: ChartType.disc,
                                  ringStrokeWidth: 32,
                                  legendOptions: const LegendOptions(
                                    showLegendsInRow: false,
                                    legendPosition: LegendPosition.right,
                                    showLegends: true,
                                  ),
                                  chartValuesOptions: const ChartValuesOptions(
                                    showChartValueBackground: true,
                                    showChartValues: true,
                                    showChartValuesOutside: false,
                                    decimalPlaces: 1,
                                  ),
                                ),
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  "Last 10 Histori",
                  style: textOpenSans.copyWith(
                    fontSize: 14,
                    fontWeight: bold,
                  ),
                ),
              ),
            ),
            const DashLineView(fillRate: 1),
            ListView.builder(
                shrinkWrap: true,
                itemCount: _dataPfgivo.length,
                itemBuilder: ((context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _dataPfgivo[index].order.toString(),
                                    style: textOpenSans.copyWith(
                                      fontSize: 16,
                                      fontWeight: bold,
                                    ),
                                  ),
                                  Text(
                                    " Order",
                                    style: textOpenSans,
                                  )
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Barang ${_dataPfgivo[index].idWorkorder}",
                                style: textOpenSans,
                              ),
                            ],
                          ),
                          Text(
                            DateFormat("yMd", "id_ID")
                                .format(_dataPfgivo[index].createdAt),
                          ),
                        ],
                      ),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }
}
