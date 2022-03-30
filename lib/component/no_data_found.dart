import 'package:flutter/material.dart';
import 'package:get/get.dart';



class NoItemFoundWidget extends StatelessWidget {

  const NoItemFoundWidget( {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   return Center(
     child: Card(child: Padding(
       padding: const EdgeInsets.all(24),
       child: Column(children: [
         Icon(Icons.search_off,size: 60,color: Colors.black,),
         Text("No Data Found!",style: Get.textTheme.bodyText1?.copyWith(color: Colors.black),)
       ],mainAxisSize: MainAxisSize.min,),
     ),),
   );
  }
}
