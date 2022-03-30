import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RechargeOptionDialog extends StatelessWidget {

  final VoidCallback onPrepaidClick;
  final VoidCallback onPostpaidClick;

  const RechargeOptionDialog({Key? key,required this.onPostpaidClick,required this.onPrepaidClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Mobile Recharge Option",style: Get.textTheme.headline6,),
          ),
          Row(children: [
           _BuildItem(
             "Prepaid",
               (){
               Get.back();
               onPrepaidClick();
               }
           ),
            _BuildItem(
                "Postpaid",
                (){
                  Get.back();
                  onPostpaidClick();
                }
            )
          ],),
        ],
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  const _BuildItem(this.title,this.onClick,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: GestureDetector(
        onTap:onClick,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/home/mobile.svg"),
                Text(title,style: Get.textTheme.bodyText1,)

              ],),
          ),
        ),
      ),
    );
  }
}
