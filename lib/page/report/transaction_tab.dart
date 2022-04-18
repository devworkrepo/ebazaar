import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
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
  AppPreference appPreference = Get.find();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabList().length, vsync: this);
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
                tabs: _tabList(),
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: _tabWidgetList(),
        ),
      ),
    );
  }

  List<Tab> _tabList() {
    var mList = [
      const Tab(text: 'Dmt'),
      const Tab(text: 'Matm'),
      const Tab(text: 'Aeps'),
      const Tab(text: 'Recharge'),
      const Tab(text: 'Credit Card'),
    ];
   if(appPreference.user.isPayout ?? false){
     mList.add(const Tab(text: 'Payout'));
   }
    return mList;
  }

  List<Widget> _tabWidgetList() {
    var mList = <Widget>[
      const MoneyReportPage(
        controllerTag: AppTag.moneyReportControllerTag,
      ),
      const AepsMatmReportPage(
        controllerTag: AppTag.matmReportControllerTag,
      ),
      const AepsMatmReportPage(
        controllerTag: AppTag.aepsReportControllerTag,
      ),
      const RechargeReportPage(),
      const CreditCardReportPage(),
    ];

    if(appPreference.user.isPayout ?? false){
      mList.add(
        const MoneyReportPage(
          controllerTag: AppTag.payoutReportControllerTag,
        ),
      );
    }
    return mList;
  }
}

