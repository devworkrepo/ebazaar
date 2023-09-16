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
        backgroundColor: Theme.of(context).primaryColorDark,
        key: bottomNavKey,
        elevation: 20,

        selectedLabelStyle: selectedTextStyle,
        unselectedLabelStyle: unSelectedTextStyle,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white60,
        // backgroundColor: Get.theme.primaryColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: bottomNavSelectedIndex,
        onTap: (index){

        },
        items:  [

          BottomNavigationBarItem(
              icon: Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(

                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.white60)
                ),
                  child: Icon(Icons.keyboard_return)), label: "Refund"),
          BottomNavigationBarItem(
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white60)
                  ),
                  child: Icon(Icons.receipt_long_rounded)),
              label: "Statement"),
          BottomNavigationBarItem(
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white60)
                  ),child: Icon(Icons.home)), label: "Home"),
          BottomNavigationBarItem(
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white60)
                  ),child: Icon(Icons.receipt_outlined)),
              label: "Transaction"),
          BottomNavigationBarItem(
              icon: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white60)
                  ),child: Icon(Icons.person)), label: "Profile"),
        ],
      ),
    );
  }
}
