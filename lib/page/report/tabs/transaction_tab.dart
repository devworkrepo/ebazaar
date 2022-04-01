import 'package:flutter/material.dart';
import 'package:spayindia/page/report/fund_report/fund_report_page.dart';
import 'package:spayindia/page/report/money_report/money_report_page.dart';
import 'package:spayindia/page/route_aware_widget.dart';
import 'package:spayindia/util/tags.dart';


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
    _tabController = TabController(length: 2, vsync: this);
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
                isScrollable: false,
                tabs: const <Tab>[
                  Tab(text: 'Dmt'),
                  Tab(text: 'Payout'),
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
          ],
        ),
      ),
    );
  }
}

