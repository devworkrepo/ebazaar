import 'package:flutter/material.dart';

class HomeBottomBarWidget extends StatelessWidget {
   HomeBottomBarWidget({Key? key}) : super(key: key);

  var bottomNavKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    var selectedTextStyle = const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
    );

    var unSelectedTextStyle = const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400);

    var bottomNavSelectedIndex = 2;

    var avatarBGColor = Colors.white70;
    var avatarFColor = Colors.black87;


    return    Theme(
      data: ThemeData(
        primaryColor: Colors.white
      ),
      child: BottomNavigationBar(

        key: bottomNavKey,
        elevation: 20,

        selectedLabelStyle: selectedTextStyle,
        unselectedLabelStyle: unSelectedTextStyle,
        selectedItemColor: Theme.of(context).primaryColorDark,
        unselectedItemColor: Colors.grey[600],
        selectedIconTheme: IconThemeData(
          color: Theme.of(context).primaryColorDark
        ),
        // backgroundColor: Get.theme.primaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavSelectedIndex,
        onTap: (index){

        },
        items:  const [

          BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_return), label: "Refund"),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_rounded),
              label: "Statement"),

          BottomNavigationBarItem(
              icon: SizedBox(height: 24,),
              label: "Home"),

          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_outlined),
              label: "Transaction"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
