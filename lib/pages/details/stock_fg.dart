import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:summary_monitoring/constan.dart';
import 'package:summary_monitoring/pages/get_started_page.dart';
import 'package:summary_monitoring/services/stock_fg_service.dart';
import '../../helper/user_info.dart';
import '../../models/api_response_model.dart';
import '../../models/stock_fg_model.dart';
import '../../theme.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

class StockFG extends StatefulWidget {
  const StockFG({Key? key}) : super(key: key);

  @override
  State<StockFG> createState() => _StockFGState();
}

class _StockFGState extends State<StockFG> {
  TextEditingController tanggal = TextEditingController();
  final String datenow = DateFormat('dd/MM/yyyy').format(DateTime.now());

  List<StockFGModel> stock = [];
  bool loading = true;
  bool _loading = true;
  List<dynamic> tabelStockList = [];

  void getData() async {
    String token = await getToken();
    var response = await http.get(
      Uri.parse(
        baseURL + "/api/fg/stock/chart",
      ),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token'
      },
    );
    List data = json.decode(response.body)['list'][0]['detail'];

    setState(() {
      //memasukan data json ke dalam model
      stock = stockModelFromJson(data);

      loading = false;
    });
  }

  List suplierlist = [];
  var valueSuplier;
  Future getSuplier() async {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(baseURL + '/api/stechoq/tabel-stock-ofg'),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token'
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['suplier'];
      setState(() {
        suplierlist = jsonData;
      });
    }
  }

  fungsigetTabelStockOpnameFg() async {
    ApiResponse response = await getTabelStockOpnameFg();
    if (response.error == null) {
      setState(() {
        tabelStockList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const GetStartedPage()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }

  List<charts.Series<StockFGModel, String>> chartStockOpnameFg() {
    return [
      charts.Series<StockFGModel, String>(
          data: stock,
          id: 'id',
          seriesColor: charts.ColorUtil.fromDartColor(primaryColor),
          domainFn: (StockFGModel stockFGModel, _) => stockFGModel.partName,
          measureFn: (StockFGModel stockFGModel, _) => stockFGModel.qty)
    ];
  }

  List<Widget> _getTitle() {
    return [
      _getTitleItemWidget('Part Number', 250),
      _getTitleItemWidget('Name Name', 230),
      _getTitleItemWidget('Min', 50),
      _getTitleItemWidget('Max', 50),
      _getTitleItemWidget('Inbound', 70),
      _getTitleItemWidget('Outbound', 80),
      _getTitleItemWidget('Sisa', 50),
      _getTitleItemWidget('Status', 70),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: const TextStyle(color: Colors.white)),
      width: width,
      color: const Color(0xff4E4E53),
      height: 30,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _firstColumnRow(BuildContext context, int index) {
    TabelStckFGModel tabelStckFGModel = tabelStockList[index];
    return Center(
      child: Container(
        child: Text(tabelStckFGModel.partNumber),
        width: 250,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _rightHandSideColumnRow(BuildContext context, int index) {
    TabelStckFGModel tabelStckFGModel = tabelStockList[index];
    return Row(
      children: <Widget>[
        ItemListTabel(pWidth: 230, value: tabelStckFGModel.partName),
        ItemListTabel(pWidth: 50, value: tabelStckFGModel.min.toString()),
        ItemListTabel(pWidth: 50, value: tabelStckFGModel.max.toString()),
        ItemListTabel(pWidth: 70, value: tabelStckFGModel.inbound.toString()),
        ItemListTabel(pWidth: 80, value: tabelStckFGModel.outbond.toString()),
        ItemListTabel(pWidth: 50, value: tabelStckFGModel.sisa.toString()),
        Container(
          color: tabelStckFGModel.status == 'normal'
              ? Colors.green
              : tabelStckFGModel.status == '0VERLOAD'
                  ? Colors.red
                  : Colors.orange,
          child: Center(
            child: Text(
              tabelStckFGModel.status,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          width: 70,
          height: 52,
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
    // });
  }

  @override
  void initState() {
    super.initState();
    getData();
    fungsigetTabelStockOpnameFg();
    // getSuplier();
    tanggal.text = datenow;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Card(
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
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Stock Opname Finish Good',
                                style: textOpenSans.copyWith(
                                  color: blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
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
                                    String formattedDate2 =
                                        DateFormat('dd/MM/yyyy')
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
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
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: charts.BarChart(
                                chartStockOpnameFg(),
                                animate: true,
                                domainAxis: const charts.OrdinalAxisSpec(
                                  renderSpec: charts.SmallTickRendererSpec(
                                    // Rotation Here,
                                    labelRotation: -90,
                                    labelAnchor: charts.TickLabelAnchor.before,
                                    labelOffsetFromTickPx: -5,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
            ),
            const SizedBox(
              height: 100,
            ),
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Stock Opname Finish Good',
                                  style: textOpenSans.copyWith(
                                    color: blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  height: 40,
                                  width: 110,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: primaryColor, width: 1.0),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        icon: const ImageIcon(
                                          AssetImage(
                                              'assets/icons/arrow-down.png'),
                                        ),
                                        dropdownColor: const Color(0xffF0F1F2),
                                        borderRadius: BorderRadius.circular(15),
                                        hint: const Text('Supplier'),
                                        items: suplierlist.map((item) {
                                          return DropdownMenuItem(
                                            value: item['name_sup'].toString(),
                                            child: Text(
                                                item['name_sup'].toString()),
                                          );
                                        }).toList(),
                                        onChanged: (newVal) {
                                          setState(() {
                                            valueSuplier = newVal;
                                            print(valueSuplier);
                                          });
                                        },
                                        value: valueSuplier,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: HorizontalDataTable(
                                leftHandSideColumnWidth: 100,
                                rightHandSideColumnWidth: 600,
                                isFixedHeader: true,
                                headerWidgets: _getTitle(),
                                leftSideItemBuilder: _firstColumnRow,
                                rightSideItemBuilder: _rightHandSideColumnRow,
                                itemCount: tabelStockList.length,
                                rowSeparatorWidget: const Divider(
                                  color: Colors.black54,
                                  height: 1.0,
                                  thickness: 0.0,
                                ),
                                // leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
                                // rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ItemListTabel extends StatelessWidget {
  const ItemListTabel({Key? key, required this.pWidth, required this.value})
      : super(key: key);

  final double pWidth;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(value),
      width: pWidth,
      height: 52,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }
}
