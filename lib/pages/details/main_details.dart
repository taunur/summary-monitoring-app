import 'package:flutter/material.dart';

import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:summary_monitoring/models/homepage_tile.dart';
import 'package:summary_monitoring/pages/details/msm.dart';
import 'package:summary_monitoring/theme.dart';

import 'mivo.dart';
import 'pfgivo.dart';
import 'sdpa.dart';
import 'sngp.dart';
import 'stock_fg.dart';

class DetailHomePage extends StatefulWidget {
  final ListBodyHome listBodyHome;
  final int index;
  const DetailHomePage(
      {Key? key, required this.listBodyHome, required this.index})
      : super(key: key);

  @override
  State<DetailHomePage> createState() => _DetailHomePageState();
}

class _DetailHomePageState extends State<DetailHomePage> {
  // Appbar
  PreferredSize getAppbar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(55.0),
      child: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: blackColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: backgrounColor1,
        centerTitle: true,
        elevation: 1,
        title: Text(
          widget.listBodyHome.title,
          style: blackTextStyle.copyWith(
            fontSize: 16,
            fontWeight: semiBold,
          ),
        ),
      ),
    );
  }

  // Body
  Widget getBody() {
    return LazyLoadIndexedStack(
      index: widget.index,
      children: const [
        MonitoringSM(),
        StockFG(),
        ProdFGInVSOut(),
        MaterialInVSOut(),
        SumNGPart(),
        SumDailyProdAchiev(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppbar(),
      body: getBody(),
    );
  }
}
