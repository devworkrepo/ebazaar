import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/status_bar_color_widget.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/page/main/home/home_page.dart';
import 'package:spayindia/page/refund/credit_card_refund/credit_card_refund_controller.dart';
import 'package:spayindia/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:spayindia/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:spayindia/page/refund/refund_tab.dart';
import 'package:spayindia/page/report/aeps_matm_report/aeps_matm_report_controller.dart';
import 'package:spayindia/page/report/credit_card_report/credit_card_report_controller.dart';
import 'package:spayindia/page/report/money_report/mone_report_controller.dart';
import 'package:spayindia/page/report/recharge_report/recharge_report_controller.dart';
import 'package:spayindia/page/report/transaction_tab.dart';
import 'package:spayindia/page/statement/account_statement/account_statement_controller.dart';
import 'package:spayindia/page/statement/credit_debit/credit_debit_controller.dart';
import 'package:spayindia/page/statement/statement_tab.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/tags.dart';
import 'package:upgrader/upgrader.dart';

var isBottomNavShowObs = true.obs;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var title = "Service";
  var bottomNavStyle =
       TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Get.theme.primaryColorDark);
  var backgroundColor = Colors.lightBlue[100];
  var bottomNavSelectedIndex = 2;
  var selectedItemColor = Get.theme.primaryColorDark;
  var bottomNavKey = GlobalKey();

  AppPreference appPreference = Get.find();

  @override
  void initState() {
    super.initState();
    setTransactionApi();
    updateCheck();

  }

  void updateCheck() async{
    var isInitialized =await Upgrader().initialize();

    AppUtil.logger("isInitialized : $isInitialized");

   var isUpdateAvailable = Upgrader().isUpdateAvailable();


    AppUtil.logger("isUpdateAvailable : $isUpdateAvailable");
  }


  @override
  Widget build(BuildContext context) {

   var value= Upgrader().isUpdateAvailable();
   AppUtil.logger("isupdate : $value");

    return WillPopScope(
      onWillPop: () async {
        if (bottomNavSelectedIndex == 2) {
          return true;
        } else {
          setState(() {
            var nav = bottomNavKey.currentWidget as BottomNavigationBar?;
            nav?.onTap!(2);
          });
          return false;
        }
      },
      child: StatusBarColorWidget(
        child: Scaffold(
          bottomNavigationBar: _buildBottomNavigationBar(),
          body: _bottomNavPage(),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => Visibility(
          visible: isBottomNavShowObs.value,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            shadowColor: Colors.blue,
            elevation: 20,
           /* decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(.8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12), )
            ),*/
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                Container(height: 1,width: Get.width,color: Colors.grey[300],),
                BottomNavigationBar(
                 backgroundColor: Colors.white,
                  key: bottomNavKey,
                  elevation: 20,

                  selectedLabelStyle: bottomNavStyle,
                  unselectedLabelStyle: bottomNavStyle,
                  selectedItemColor: selectedItemColor,
                   unselectedItemColor: Colors.black45,
                  // backgroundColor: Get.theme.primaryColor,
                  type: BottomNavigationBarType.fixed,
                  currentIndex: bottomNavSelectedIndex,
                  onTap: _onBottomNavItemClick,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.keyboard_return), label: "Refund"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_long_rounded), label: "Settlement"),
                    BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_outlined), label: "Report"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person), label: "Profile"),
                  ],
                ),
              ],
            ),
          ),
        ));

    return ConvexAppBar(
      key: bottomNavKey,
      backgroundColor: Get.theme.primaryColorDark,

      style: TabStyle.textIn,
      elevation: 8,
      items: [
        TabItem(icon: Icons.keyboard_return, title: 'Refund'),
        TabItem(icon: Icons.receipt_outlined, title: 'Settlement'),
        TabItem(icon: Icons.home, title: 'Home'),
        TabItem(icon: Icons.receipt_long_rounded, title: 'Report'),
        TabItem(icon: Icons.people, title: 'Profile'),
      ],
      initialActiveIndex: 2,//optional, default as 0
      onTap: (int i) => setState(() {
        bottomNavSelectedIndex = i;
      }),
    );
  }

  void _onBottomNavItemClick(position) {
    setState(() {
      selectedItemColor = Get.theme.primaryColorDark;
      bottomNavSelectedIndex = position;
      if (position == 0) {
        title = "Service";
      } else if (position == 1) {
        title = "Transaction";
      }
    });
  }

  _bottomNavPage() {
    switch (bottomNavSelectedIndex) {
      case 0:
        Get.delete<DmtRefundController>(tag: AppTag.payoutRefundControllerTag);
        Get.delete<DmtRefundController>(tag: AppTag.moneyRefundControllerTag);
        Get.delete<RechargeRefundController>();
        Get.delete<CreditCardRefundController>();
        return const RefundTabPage();
      case 1:
        Get.delete<AccountStatementController>(tag: AppTag.accountStatementControllerTag);
        Get.delete<AccountStatementController>(tag: AppTag.aepsStatementControllerTag);
        Get.delete<CreditDebitController>(tag: AppTag.creditStatementControllerTag);
        Get.delete<CreditDebitController>(tag: AppTag.debitStatementControllerTag);
        return const StatementTabPage();
      case 2:
        return const HomePage();
      case 3:
        Get.delete<MoneyReportController>(tag: AppTag.payoutReportControllerTag);
        Get.delete<MoneyReportController>(tag: AppTag.moneyReportControllerTag);
        Get.delete<RechargeReportController>();
        Get.delete<AepsMatmReportController>(tag: AppTag.aepsReportControllerTag);
        Get.delete<AepsMatmReportController>(tag: AppTag.matmReportControllerTag);
        Get.delete<CreditCardReportController>();
        return const TransactionTabPage();
      default:
        return Center(
          child: Text(
            "Work on Progress",
            style: Get.textTheme.headline6,
          ),
        );
    }
  }

  void setTransactionApi() async {
   await appPreference.setIsTransactionApi(false);

  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 32;

  @override
  double get activeIconMargin => 14;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color) {
    return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.w500);
  }
}