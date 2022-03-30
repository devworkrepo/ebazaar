import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/status_bar_color_widget.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/page/main/home/home_page.dart';
import 'package:spayindia/page/report/tabs/transaction_tab.dart';


var isBottomNavShowObs = true.obs;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var title = "Service";
  var bottomNavStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.white70);
  var backgroundColor = Colors.lightBlue[100];
  var bottomNavSelectedIndex = 2;
  var selectedItemColor = Colors.white;
  var bottomNavKey = GlobalKey();

  AppPreference appPreference = Get.find();

  @override
  void initState() {
    super.initState();
    appPreference.setIsTransactionApi(false);
    abc();
  }

  void abc() async {

  }

  @override
  Widget build(BuildContext context) {
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
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withOpacity(.8),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12), )
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              key: bottomNavKey,
              elevation: 10,
              selectedLabelStyle: bottomNavStyle,
              unselectedLabelStyle: bottomNavStyle,
              selectedItemColor: selectedItemColor,
               unselectedItemColor: Colors.white60,
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
      selectedItemColor = Colors.white;
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

      case 2:
        return HomePage();
      case 3:
        return TransactionTabPage();
      default :
        return Center(child: Text("Work on Progress",style: Get.textTheme.headline6,) ,);
    }
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