import 'package:flutter/material.dart';
import 'package:spayindia/page/refund/credit_card_refund/credit_card_refund_page.dart';
import 'package:spayindia/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:spayindia/page/refund/recharge_refund/recharge_refund_page.dart';
import 'package:spayindia/util/tags.dart';

import 'dmt_refund/dmt_refund_page.dart';


class RefundTabPage extends StatefulWidget {
  const RefundTabPage({Key? key}) : super(key: key);

  @override
  State<RefundTabPage> createState() => _RefundTabPageState();
}

class _RefundTabPageState extends State<RefundTabPage>
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
              centerTitle: true,
              title: const Text('Refund'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: TabBar(
                isScrollable: true,
                tabs: const <Tab>[
                  Tab(text: 'Money'),
                  Tab(text: 'Payout'),
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
            DmtRefundPage(controllerTag: AppTag.moneyRefundControllerTag,),
            DmtRefundPage(controllerTag: AppTag.payoutRefundControllerTag,),
            RechargeRefundPage(),
            CreditCardRefundPage()
          ],
        ),
      ),
    );
  }
}

