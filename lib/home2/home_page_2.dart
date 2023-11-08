import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ebazaar/home2/home_2_carousel_widget.dart';
import 'package:ebazaar/home2/home_appbar_widget.dart';
import 'package:ebazaar/home2/home_bottom_bar_widget.dart';
import 'package:ebazaar/home2/home_header.dart';
import 'package:ebazaar/home2/home_service_card.dart';
import 'package:ebazaar/res/color.dart';
import 'package:ebazaar/util/hex_color.dart';

import '../widget/image.dart';
import 'home_suggestion_widget.dart';

class HomePage2 extends StatelessWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.menu),
        titleSpacing: 0,
        backgroundColor: Theme.of(context).primaryColorDark,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        excludeHeaderSemantics: true,
        title: HomePage2AppBar(),
      ),*/
      backgroundColor: AppColor.backgroundColor,
      body: Stack(
        children: [
          Container(
            decoration:
                BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                     Theme.of(context).primaryColorDark,
                     Theme.of(context).primaryColorDark,
                     Theme.of(context).colorScheme.secondary,
                      ]
                    )
                ),
            height: MediaQuery.of(context).size.height / 2.5,
            width: double.infinity,
            child: CustomPaint(
              painter: RPSCustomPainter(),
              child: CustomPaint(
                painter: RPSCustomPainter(),
                child: CustomPaint(
                  painter: RPSCustomPainter2(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            Container(
                              height: 42,
                              width: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Icon(
                                    Icons.menu,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Expanded(
                                child: Card(
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(300)),
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Search",
                                          border: InputBorder.none,
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.w500),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 15),
                                          suffixIcon: Icon(
                                            Icons.search,
                                          )),
                                    ))),
                            SizedBox(
                              width: 12,
                            ),
                            Container(
                              height: 42,
                              width: 42,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              padding: EdgeInsets.all(4),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Icon(
                                    Icons.message,
                                    color: Colors.white.withOpacity(0.9),
                                    size: 24,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      height: 18,
                                      width: 18,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(100)),
                                      child: Text(
                                        "1",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 24),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AB Communication",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Available Balance",
                                      style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius: BorderRadius.circular(50),
                                          border: Border.all(
                                            color: Colors.white38,
                                          )),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 4),
                                      margin: EdgeInsets.symmetric(horizontal: 0),
                                      child: Row(
                                        children: [
                                          Text(
                                            "₹123000",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 24),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          CircleAvatar(
                                              radius: 15, child: Icon(Icons.add)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Spacer(),
                            AppCircleNetworkImage(
                                "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1470&q=80"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.7 - (30),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: AppColor.backgroundColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //  const HomeHeaderSection(),
                      // HomeCarouselWidget(),
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
                        height: 32,
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
                        HomeCardItem(
                            iconName: "ic_broadband", title: "Landline"),
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
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomBarWidget(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(0),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColorDark,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onPressed: () {},
          child: Container(

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).colorScheme.secondary,
                ]
              ),
              borderRadius: BorderRadius.circular(5)
            ),
             child: Container(
               clipBehavior: Clip.antiAlias,
               margin: EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(5)
                 ),
                 child: Image.asset("assets/image/logo_2.png",))
          ),
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
    path.lineTo(0, height - 100);

    path.quadraticBezierTo(width / 2, height, width, height - 100);

    path.lineTo(width, height - 100);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color =  Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*-0.0006600,size.height*0.7006667);
    path_0.quadraticBezierTo(size.width*0.0198800,size.height*0.6028000,size.width*0.1091800,size.height*0.5524500);
    path_0.cubicTo(size.width*0.1851600,size.height*0.5042333,size.width*0.2983600,size.height*0.4778833,size.width*0.4388200,size.height*0.4546500);
    path_0.cubicTo(size.width*0.5636400,size.height*0.4235833,size.width*0.6241400,size.height*0.2949667,size.width*0.7561400,size.height*0.2029167);
    path_0.quadraticBezierTo(size.width*0.8791400,size.height*0.1407167,size.width*1.0033200,size.height*0.1273000);
    path_0.lineTo(size.width*0.9980000,size.height*0.9983333);
    path_0.lineTo(size.width*0.0040000,size.height*1.0016667);
    path_0.lineTo(size.width*-0.0006600,size.height*0.7006667);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);





  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}

class RPSCustomPainter2 extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    // Layer 1

    Paint paint_fill_0 = Paint()
      ..color = Colors.black.withOpacity(0.1)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;


    Path path_0 = Path();
    path_0.moveTo(size.width*0.2123600,size.height*0.7627667);
    path_0.cubicTo(size.width*0.2616200,size.height*0.7153500,size.width*0.4412000,size.height*0.6400167,size.width*0.4691400,size.height*0.6124667);
    path_0.cubicTo(size.width*0.5090800,size.height*0.5895667,size.width*0.5804600,size.height*0.4929000,size.width*0.6015800,size.height*0.4523333);
    path_0.cubicTo(size.width*0.6302450,size.height*0.4182708,size.width*0.6351000,size.height*0.3828500,size.width*0.7162400,size.height*0.3160833);
    path_0.quadraticBezierTo(size.width*0.8446000,size.height*0.2262000,size.width*1.0139600,size.height*0.2315667);
    path_0.lineTo(size.width*0.9980000,size.height*0.9983333);
    path_0.lineTo(size.width*0.0894600,size.height*1.0127333);
    path_0.quadraticBezierTo(size.width*0.1467800,size.height*0.8152000,size.width*0.2123600,size.height*0.7627667);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);


    // Layer 1

    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(0, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;



    canvas.drawPath(path_0, paint_stroke_0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}








