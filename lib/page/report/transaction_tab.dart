import 'package:flutter/material.dart';
import 'package:spayindia/model/report/credit_card.dart';
import 'package:spayindia/page/credit_card/credit_card_page.dart';
import 'package:spayindia/page/report/credit_card_report/credit_card_report_page.dart';
import 'package:spayindia/page/report/money_report/money_report_page.dart';
import 'package:spayindia/page/report/recharge_report/recharge_report_page.dart';
import 'package:spayindia/util/tags.dart';

import 'aeps_matm_report/aeps_matm_report_page.dart';


class TransactionTabPage extends StatefulWidget {
  const TransactionTabPage({Key? key}) : super(key: key);

  @override
  State<TransactionTabPage> createState() => _TransactionTabPageState();
}

class _TransactionTabPageState extends State<TransactionTabPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext mContext, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              centerTitle: true,
              title: const Text('Transaction Report'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: const <Tab>[
                  Tab(text: 'Dmt'),
                  Tab(text: 'Payout'),
                  Tab(text: 'Matm'),
                  Tab(text: 'Aeps'),
                  Tab(text: 'Recharge'),
                  Tab(text: 'Credit Card'),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            MoneyReportPage(controllerTag: AppTag.moneyReportControllerTag,),
            MoneyReportPage(controllerTag: AppTag.payoutReportControllerTag,),
            AepsMatmReportPage(controllerTag: AppTag.matmReportControllerTag,),
            AepsMatmReportPage(controllerTag: AppTag.aepsReportControllerTag,),
            RechargeReportPage(),
            CreditCardReportPage(),
          ],
        ),
      ),
    );
  }
}

