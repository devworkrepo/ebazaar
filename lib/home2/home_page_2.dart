import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spayindia/home2/home_2_carousel_widget.dart';
import 'package:spayindia/home2/home_appbar_widget.dart';
import 'package:spayindia/home2/home_bottom_bar_widget.dart';
import 'package:spayindia/home2/home_header.dart';
import 'package:spayindia/home2/home_service_card.dart';
import 'package:spayindia/res/color.dart';
import 'package:spayindia/util/hex_color.dart';

import 'home_suggestion_widget.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.menu),
        titleSpacing: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        excludeHeaderSemantics: true,
        title: HomePage2AppBar(),
      ),
      backgroundColor: HexColor("fff7fd"),
      body: Stack(
        children: [
          ClipPath(

            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorDark,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height / 4,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [

                      Colors.white,

                      Colors.white,
                    ]
                  )

                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeaderSection(),
                HomeCarouselWidget(),
                /*SuggestionWidget(
                title: "Service Offer",
                message: "Recharges, Bills, Flights & More",
                cardColors: [

                  Theme.of(context).colorScheme.secondary.withOpacity(0.4),
                  Theme.of(context).primaryColorDark,
                ],
                actionIcon: Icons.money,
                actionTitle: "Add Fund"),*/
                const SizedBox(
                  height: 10,
                ),
                const HomeServiceCard(title: "Money & AEPS", items: [
                  HomeCardItem(iconName: "ic_money", title: "DMT"),
                  HomeCardItem(iconName: "ic_aeps", title: "Matm / Mpos"),
                  HomeCardItem(iconName: "ic_aeps", title: "AEPS"),
                  HomeCardItem(iconName: "ic_aeps", title: "Aadhaar Pay"),
                ]),
                const HomeServiceCard(title: "Utilities & Bills", items: [
                  HomeCardItem(
                      iconName: "ic_electricity", title: "Electricity"),
                  HomeCardItem(iconName: "ic_water", title: "Water"),
                  HomeCardItem(iconName: "ic_gas", title: "Gas"),
                  HomeCardItem(iconName: "ic_broadband", title: "Landline"),
                ]),
                const HomeServiceCard(title: "Recharges", items: [
                  HomeCardItem(iconName: "ic_mobile", title: "Mobile"),
                  HomeCardItem(iconName: "ic_dth", title: "DTH"),
                  HomeCardItem(iconName: "ic_fastag", title: "Fastag"),
                ]),

                SizedBox(
                  height: 40,
                )
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: HomeBottomBarWidget(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(0),
        child: FloatingActionButton.small(
          backgroundColor: Theme.of(context).primaryColorDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {},
          child: Icon(Icons.home),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}


class _MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    double width = size.width;


    var path = Path();
    path.lineTo(0, height-100);

    path.quadraticBezierTo(width/2, height, width, height-100);


    path.lineTo(width, height -100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}