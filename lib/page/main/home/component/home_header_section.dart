import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/widget/image.dart';
import 'package:ebazaar/page/main/home/home_controller.dart';
import 'package:ebazaar/util/app_constant.dart';
import 'package:ebazaar/util/hex_color.dart';


class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8,bottom: 0,right: 12,left: 12),
      child: Card(
        color: HexColor("0f1c4c"),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             _UserProfileAndCompanyName(),
              _UserBalance()
              
            ],
          ),
        ),
      ),
    );
  }
}



class _UserBalance extends GetView<HomeController> {
  const _UserBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Available Balance",style: TextStyle(color: HexColor("2ebf14"),fontWeight: FontWeight.w500,fontSize: 16),),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(children: [
            Image.asset("assets/image/money_bag.png",height: 24,width: 24,color: Colors.white,),
            const SizedBox(width: 8,),
            Text(controller.user.availableBalance ?? "0",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700,fontSize: 24),),


          ],),
        ),


        if(controller.appPreference.user.isMoneyRequest ?? true)

          if(controller.appPreference.user.userType == "Retailer")GestureDetector(
          onTap: ()=>controller.onAddFundClick(),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white70
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.add),
                SizedBox(width: 8,),
                Text("Add Fund",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),)
              ],
            ),
          ),
        )
      ],
    );
  }
}



class _UserProfileAndCompanyName extends GetView<HomeController> {
  const _UserProfileAndCompanyName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        SizedBox(
          width: 160,
          child: Text(controller.user.outletName.toString(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white70,fontWeight: FontWeight.w500,fontSize: 16),
          ),
        ),

        SizedBox(height: 8,),

        AppCircleNetworkImage(AppConstant.profileBaseUrl+controller.user.picName.toString(),size: 70,),

      ],
    );
  }
}

