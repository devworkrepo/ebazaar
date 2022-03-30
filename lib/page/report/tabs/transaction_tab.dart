import 'package:flutter/material.dart';
import 'package:spayindia/page/report/fund_report/fund_report_page.dart';
import 'package:spayindia/page/report/money_report/money_report_page.dart';
import 'package:spayindia/page/route_aware_widget.dart';


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
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext mContext, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              title: const Text('Transaction Report'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: const <Tab>[
                  Tab(text: 'Money'),
                  Tab(text: 'Recharge'),
                  Tab(text: 'Aeps'),
                  Tab(text: 'Matm'),
                ],
                controller: _tabController,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: const <Widget>[
            MoneyReportPage(),
            MoneyReportPage(),
            MoneyReportPage(),
            MoneyReportPage(),
          ],
        ),
      ),
    );
  }
}

