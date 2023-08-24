import 'dart:convert';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

import '../../constan.dart';
import 'package:http/http.dart' as http;
import '../../helper/user_info.dart';
import '../../models/api_response_model.dart';
import '../../models/msm_model.dart';

import '../../services/msm_service.dart';

import '../../theme.dart';
import '../get_started_page.dart';
import 'stock_fg.dart';

class MonitoringSM extends StatefulWidget {
  const MonitoringSM({Key? key}) : super(key: key);

  @override
  State<MonitoringSM> createState() => _MonitoringSMState();
}

class _MonitoringSMState extends State<MonitoringSM> {
  bool loading = true;
  List stockMaterial = [];
  bool _loading = true;
  List<dynamic> tabelStockList = [];

  void getData() async {
    String token = await getToken();
    var response = await http.get(
      Uri.parse(
        baseURL + "/api/mStocks/stocks",
      ),
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'Authorization': 'Bearer $token'
      },
    );
    var data = json.decode(response.body)['list']['data'];
    setState(() {
      // stock = stockModelFromJson(data);
      stockMaterial = data;
      loading = false;
    });
  }

  List suplierlist = [];
  // ignore: prefer_typing_uninitialized_variables
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
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body)['suplier'];
      setState(() {
        suplierlist = jsonData;
      });
    }
  }

  fungsigetTabelMontoringMaterial() async {
    ApiResponse response = await getTabelMontoringMaterial();
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

  List<Widget> _getTitle() {
    return [
      _getTitleItemWidget('Type', 100),
      _getTitleItemWidget('Name', 230),
      _getTitleItemWidget('Weight', 80),
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
    MsmModel msmModel = tabelStockList[index];
    return Center(
      child: Container(
        child: Text(msmModel.type),
        width: 100,
        height: 52,
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget _rightHandSideColumnRow(BuildContext context, int index) {
    MsmModel msmModel = tabelStockList[index];
    return Row(
      children: <Widget>[
        ItemListTabel(pWidth: 230, value: msmModel.batchMaterialName),
        ItemListTabel(pWidth: 80, value: msmModel.actual.toString()),
        Container(
          color: Colors.red,
          child: const Center(
            child: Text(
              'Over',
              style: TextStyle(color: Colors.white),
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
    fungsigetTabelMontoringMaterial();
    // getSuplier();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Card(
              child: loading
                  ? SizedBox(
                      height: 500,
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
                          child: Text(
                            'Monitoring Stock Material',
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
                        AspectRatio(
                          aspectRatio: 16 / 9,
                          child: DChartPie(
                            data: stockMaterial.map((e) {
                              return {
                                'domain': e['material_name'],
                                'measure': e['weight']
                              };
                            }).toList(),
                            fillColor: ((pieData, index) {
                              switch (index) {
                                case 0:
                                  return const Color(0xff0263FF);
                                case 1:
                                  return const Color(0xff8E30FF);
                                case 2:
                                  return const Color(0xffFF7723);
                                case 3:
                                  return const Color(0xffe17055);
                                case 4:
                                  return const Color(0xff6c5ce7);
                                default:
                              }
                            }),
                            labelPadding: 20,
                            labelLineColor: primaryColor,
                            labelColor: Colors.transparent,
                            // labelPosition: PieLabelPosition.outside,
                            labelFontSize: 12,
                            labelLinelength: 16,
                            // pieLabel: (pieData, index) {
                            //   return pieData['domain'] +
                            //       ' : \n' +
                            //       pieData['measure'].toString();
                            // },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15, right: 15, top: 15),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 60,
                                width: 50,
                                child: Card(
                                  child: Center(
                                    child: Text(
                                      stockMaterial.length.toString(),
                                      style: textOpenSans.copyWith(
                                        color: blackColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 60,
                                  width: 50,
                                  child: Card(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 10),
                                      child: Text(
                                        'Material Stock',
                                        style: textOpenSans.copyWith(
                                          color: blackColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: stockMaterial.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        color: stockMaterial[index]
                                                    ['material_id'] ==
                                                0
                                            ? const Color(0xff0263FF)
                                            : stockMaterial[index]
                                                        ['material_id'] ==
                                                    1
                                                ? const Color(0xff8E30FF)
                                                : stockMaterial[index]
                                                            ['material_id'] ==
                                                        2
                                                    ? const Color(0xffFF7723)
                                                    : stockMaterial[index][
                                                                'material_id'] ==
                                                            3
                                                        ? const Color(
                                                            0xffe17055)
                                                        : const Color(
                                                            0xff6c5ce7),
                                        height: 10,
                                        width: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '${stockMaterial[index]['weight'].toString()} Kg',
                                            style: textOpenSans.copyWith(
                                              color: blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            stockMaterial[index]
                                                ['material_name'],
                                            style: textOpenSans.copyWith(
                                              color: blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: _loading
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
                              children: [
                                Text(
                                  'Supplier Monitoring Material',
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
                            Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: primaryColor),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Type',
                                      style: textOpenSans.copyWith(
                                        color: blackColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Min Stock(gr)',
                                      style: textOpenSans.copyWith(
                                        color: blackColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Max Stock(gr)',
                                      style: textOpenSans.copyWith(
                                        color: blackColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                MsmModel msmModel = tabelStockList[index];
                                return Container(
                                  height: 35,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    left: BorderSide(
                                        width: 1, color: black2Color),
                                    right: BorderSide(
                                        width: 1, color: black2Color),
                                    bottom: BorderSide(
                                        width: 1, color: black2Color),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          msmModel.type,
                                          style: textOpenSans.copyWith(
                                            color: blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          msmModel.qtyMin.toString(),
                                          style: textOpenSans.copyWith(
                                            color: blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          msmModel.qtyMax.toString(),
                                          style: textOpenSans.copyWith(
                                            color: blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              child: HorizontalDataTable(
                                leftHandSideColumnWidth: 50,
                                rightHandSideColumnWidth: 380,
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
            ),
            // SizedBox(
            //   height: 500,
            //   width: MediaQuery.of(context).size.width,
            //   child: Card(
            //     child: Padding(
            //       padding: const EdgeInsets.all(15.0),
            //       child: _loading
            //           ? SizedBox(
            //               height: 400,
            //               child: Center(
            //                 child: CircularProgressIndicator(
            //                   color: primaryColor,
            //                 ),
            //               )
            //             : Column(
            //                 children: [
            //                   Row(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.spaceBetween,
            //                     children: [
            //                       Text(
            //                         'Supplier Monitoring Material',
            //                         style: textOpenSans.copyWith(
            //                           color: blackColor,
            //                           fontSize: 14,
            //                           fontWeight: FontWeight.w700,
            //                         ),
            //                       ),
            //                       const SizedBox(
            //                         width: 10,
            //                       ),
            //                       Container(
            //                         height: 40,
            //                         width: 110,
            //                         decoration: BoxDecoration(
            //                             border: Border.all(
            //                                 color: primaryColor, width: 1.0),
            //                             borderRadius:
            //                                 BorderRadius.circular(10)),
            //                         child: Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: DropdownButtonHideUnderline(
            //                             child: DropdownButton(
            //                               icon: const ImageIcon(
            //                                 AssetImage(
            //                                     'assets/icons/arrow-down.png'),
            //                               ),
            //                               dropdownColor:
            //                                   const Color(0xffF0F1F2),
            //                               borderRadius:
            //                                   BorderRadius.circular(15),
            //                               hint: const Text('Supplier'),
            //                               items: suplierlist.map((item) {
            //                                 return DropdownMenuItem(
            //                                   value:
            //                                       item['name_sup'].toString(),
            //                                   child: Text(
            //                                       item['name_sup'].toString()),
            //                                 );
            //                               }).toList(),
            //                               onChanged: (newVal) {
            //                                 setState(() {
            //                                   valueSuplier = newVal;
            //                                   print(valueSuplier);
            //                                 });
            //                               },
            //                               value: valueSuplier,
            //                             ),
            //                             dropdownColor: Color(0xffF0F1F2),
            //                             borderRadius: BorderRadius.circular(15),
            //                             hint: const Text('Supplier'),
            //                             items: suplierlist.map((item) {
            //                               return DropdownMenuItem(
            //                                 value: item['name_sup'].toString(),
            //                                 child: Text(
            //                                     item['name_sup'].toString()),
            //                               );
            //                             }).toList(),
            //                             onChanged: (newVal) {
            //                               setState(() {
            //                                 valueSuplier = newVal;
            //                                 print(valueSuplier);
            //                               });
            //                             },
            //                             value: valueSuplier,
            //                           ),
            //                         ),
            //                       ),
            //                   ],
            //                 ),
            //                 const SizedBox(
            //                   height: 20,
            //                 ),
            //                 Container(
            //                   height: 35,
            //                   width: MediaQuery.of(context).size.width,
            //                   decoration: BoxDecoration(
            //                     border:
            //                         Border.all(width: 1, color: primaryColor),
            //                   ),
            //                   child: Padding(
            //                     padding:
            //                         const EdgeInsets.symmetric(horizontal: 10),
            //                     child: Row(
            //                       mainAxisAlignment:
            //                           MainAxisAlignment.spaceBetween,
            //                       children: [
            //                         Text(
            //                           'Type',
            //                           style: textOpenSans.copyWith(
            //                             color: blackColor,
            //                             fontSize: 12,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                         Text(
            //                           'Min Stock(gr)',
            //                           style: textOpenSans.copyWith(
            //                             color: blackColor,
            //                             fontSize: 12,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                         Text(
            //                           'Max Stock(gr)',
            //                           style: textOpenSans.copyWith(
            //                             color: blackColor,
            //                             fontSize: 12,
            //                             fontWeight: FontWeight.w600,
            //                           ),
            //                         ),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 ListView.builder(
            //                   shrinkWrap: true,
            //                   physics: const NeverScrollableScrollPhysics(),
            //                   itemCount: 2,
            //                   itemBuilder: (context, index) {
            //                     MsmModel msmModel = tabelStockList[index];
            //                     return Container(
            //                       height: 35,
            //                       width: MediaQuery.of(context).size.width,
            //                       decoration: BoxDecoration(
            //                           border: Border(
            //                         left: BorderSide(
            //                             width: 1, color: black2Color),
            //                         right: BorderSide(
            //                             width: 1, color: black2Color),
            //                         bottom: BorderSide(
            //                             width: 1, color: black2Color),
            //                       )),
            //                       child: Padding(
            //                         padding: const EdgeInsets.symmetric(
            //                             horizontal: 10),
            //                         child: Row(
            //                           mainAxisAlignment:
            //                               MainAxisAlignment.spaceBetween,
            //                           children: [
            //                             Text(
            //                               msmModel.type,
            //                               style: textOpenSans.copyWith(
            //                                 color: blackColor,
            //                                 fontSize: 12,
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                             ),
            //                             Text(
            //                               msmModel.qtyMin.toString(),
            //                               style: textOpenSans.copyWith(
            //                                 color: blackColor,
            //                                 fontSize: 12,
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                             ),
            //                             Text(
            //                               msmModel.qtyMax.toString(),
            //                               style: textOpenSans.copyWith(
            //                                 color: blackColor,
            //                                 fontSize: 12,
            //                                 fontWeight: FontWeight.w600,
            //                               ),
            //                             ),
            //                           ],
            //                         ),
            //                       ),
            //                     );
            //                   },
            //                 ),
            //                 const SizedBox(
            //                   height: 20,
            //                 ),
            //                 Expanded(
            //                   child: HorizontalDataTable(
            //                     leftHandSideColumnWidth: 50,
            //                     rightHandSideColumnWidth: 380,
            //                     isFixedHeader: true,
            //                     headerWidgets: _getTitle(),
            //                     leftSideItemBuilder: _firstColumnRow,
            //                     rightSideItemBuilder: _rightHandSideColumnRow,
            //                     itemCount: tabelStockList.length,
            //                     rowSeparatorWidget: const Divider(
            //                       color: Colors.black54,
            //                       height: 1.0,
            //                       thickness: 0.0,
            //                     ),
            //                     // leftHandSideColBackgroundColor: Color(0xFFFFFFFF),
            //                     // rightHandSideColBackgroundColor: Color(0xFFFFFFFF),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
