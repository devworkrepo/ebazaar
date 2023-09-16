import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spayindia/home2/home_appbar_widget.dart';
import 'package:spayindia/home2/home_bottom_bar_widget.dart';
import 'package:spayindia/home2/home_header.dart';
import 'package:spayindia/home2/home_service_card.dart';
import 'package:spayindia/util/hex_color.dart';

import 'home_suggestion_widget.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        titleSpacing: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        excludeHeaderSemantics: true,

        title: HomePage2AppBar(),
      ),
      backgroundColor: HexColor("fff7fd"),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [


            HomeHeaderSection(),

            SuggestionWidget(
                title: "Service Offer",
                message: "Recharges, Bills, Flights & More",
                cardColors: [
                  Colors.green[900]!,
                  Theme.of(context).primaryColorDark,
                ],
                actionIcon: Icons.money,
                actionTitle: "Add Fund"),
            const SizedBox(
              height: 20,
            ),
            SuggestionWidget(
                title: "Scan & Pay",
                message: "Pay to Vendors, Friends, Shops * More",
                cardColors: [
                  Theme.of(context).primaryColorDark,
                  Colors.green[900]!,
                ],
                actionIcon: Icons.qr_code,
                actionTitle: "Scan"),
            const SizedBox(
              height: 20,
            ),
            const HomeServiceCard(title: "Money & AEPS", items: [
              HomeCardItem(iconName: "money", title: "DMT"),
              HomeCardItem(iconName: "matm", title: "Matm / Mpos"),
              HomeCardItem(iconName: "aeps", title: "AEPS"),
              HomeCardItem(iconName: "aeps", title: "Aadhaar Pay"),


            ]),

            const HomeServiceCard(title: "Utilities & Bills", items: [
              HomeCardItem(
                  iconName: "electricity", title: "Electricity"),
              HomeCardItem(iconName: "water", title: "Water"),
              HomeCardItem(iconName: "gas", title: "Gas"),
              HomeCardItem(
                  iconName: "landline", title: "Landline"),
            ]),

            const HomeServiceCard(title: "Recharges", items: [
              HomeCardItem(iconName: "mobile", title: "Mobile"),
              HomeCardItem(iconName: "dth", title: "DTH"),
              HomeCardItem(iconName: "fastag", title: "Fastag"),
            ]),

          ],
        ),
      ),
      bottomNavigationBar: HomeBottomBarWidget(),
    );
  }
}


