import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/main/home/home_controller.dart';

class HomeCommissionSummaryWidget extends GetView<HomeController> {
  const HomeCommissionSummaryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Investment Summary",
                style: Get.textTheme.subtitle2?.copyWith(
                    fontWeight: FontWeight.w600, color: Colors.grey[700]),
              ),
              const Divider(),
              const SizedBox(
                height: 8,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    _buildItem(
                        Colors.blue[500],Colors.blue[600], "Active Investments", "10",rupee: false),
                    const SizedBox(
                      width: 8,
                    ),
                    _buildItem(
                        Colors.blue[500],Colors.blue[600], "Total Amount", "117"),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    _buildItem(
                        Colors.green[500],Colors.green[600],"Interest Earned", "1276"),
                    SizedBox(
                      width: 8,
                    ),
                    _buildItem( Colors.blue[500],Colors.blue[600], "Completed Investment", "117"),
                  ],
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              IntrinsicHeight(
                child: Row(
                  children: [
                    _buildItem(
                        Colors.green[500],Colors.green[600], "Current Available Amount", "1276"),
                   
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),


            ],
          ),
        ),
      ),
    );
  }

  Expanded _buildItem(Color? color1, Color? color2, String title, String value,
      {bool rupee = true, VoidCallback? onClick}) {
    return Expanded(
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            if(onClick != null) onClick();
          },
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [color1!, color2!]),
                    borderRadius: BorderRadius.circular(4)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, right: 8, top: 8),
                      child: Text(
                        (rupee) ? "₹ $value" : "$value",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Helvetica'
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Divider(
                      color: Colors.white.withOpacity(0.1),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Text(
                        title,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            fontFamily: 'Helvetica'
                        ),
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.15),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60))
                  ),

                ),
              ),
            ],
          ),
        ));
  }
}

