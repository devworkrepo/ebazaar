import 'dart:io';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/status_bar_color_widget.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/page/main/home/home_page.dart';
import 'package:spayindia/page/profile/prifle_page.dart';
import 'package:spayindia/page/refund/credit_card_refund/credit_card_refund_controller.dart';
import 'package:spayindia/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:spayindia/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:spayindia/page/refund/refund_tab.dart';
import 'package:spayindia/page/report/aeps_matm_report/aeps_matm_report_controller.dart';
import 'package:spayindia/page/report/credit_card_report/credit_card_report_controller.dart';
import 'package:spayindia/page/report/money_report/money_report_controller.dart';
import 'package:spayindia/page/report/recharge_report/recharge_report_controller.dart';
import 'package:spayindia/page/report/transaction_tab.dart';
import 'package:spayindia/page/statement/account_statement/account_statement_controller.dart';
import 'package:spayindia/page/statement/credit_debit/credit_debit_controller.dart';
import 'package:spayindia/page/statement/statement_tab.dart';
import 'package:spayindia/page/update_widget.dart';
import 'package:spayindia/res/style.dart';
import 'package:spayindia/route/route_name.dart';
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
  var bottomNavStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Get.theme.primaryColorDark);
  var backgroundColor = Colors.lightBlue[100];
  var bottomNavSelectedIndex = 2;
  var selectedItemColor = Get.theme.primaryColorDark;
  var bottomNavKey = GlobalKey();

  AppPreference appPreference = Get.find();

  @override
  void initState() {
    super.initState();
    setTransactionApi();

  }

  @override
  Widget build(BuildContext context) {

   var value= Upgrader().isUpdateAvailable();
   AppUtil.logger("isupdate : $value");

    return WillPopScope(
      onWillPop: () async {
        if (bottomNavSelectedIndex == 2) {

            showExitDialog();
            return false;

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
                        icon: Icon(Icons.receipt_long_rounded),
                        label: "Statement"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.receipt_outlined),
                        label: "Transaction"),
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
        Get.delete<MoneyReportController>(
            tag: AppTag.payoutReportControllerTag);
        Get.delete<MoneyReportController>(tag: AppTag.moneyReportControllerTag);
        Get.delete<RechargeReportController>();
        Get.delete<AepsMatmReportController>(
            tag: AppTag.aepsReportControllerTag);
        Get.delete<AepsMatmReportController>(
            tag: AppTag.matmReportControllerTag);
        Get.delete<CreditCardReportController>();
        return const TransactionTabPage();
      case 4:
        return const ProfilePage();
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

  void showExitDialog() async {
    Get.bottomSheet(Container(
      decoration: AppStyle.bottomSheetDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Exit or Logout ? ",
              style: Get.textTheme.headline3
                  ?.copyWith(color: Get.theme.primaryColorDark),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                "If you logout then login session will destroy and need to login with otp again.",
                style: Get.textTheme.bodyText1?.copyWith(
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                  text: "Logout",
                  onClick: () {
                    Get.back();
                    appPreference.logout().then((value){
                     Get.offAllNamed(AppRoute.loginPage);
                    });
                  },
                  background: Colors.red,
                )),
                const SizedBox(width: 16,),
                Expanded(
                    child: AppButton(
                      text: "Exit",
                      onClick: () {
                        Get.back();
                        SystemNavigator.pop();
                      },
                      background: Get.theme.primaryColorDark,
                    ))
              ],
            )
          ],
        ),
      ),
    ));
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