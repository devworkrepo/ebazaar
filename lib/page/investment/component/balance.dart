import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/investment/inventment_balance.dart';

import '../../../util/app_constant.dart';

class InvestmentBalanceWidget extends StatelessWidget {
  final InvestmentBalanceResponse data;
  final bool showPanWarning;
  const InvestmentBalanceWidget(this.data, {Key? key,this.showPanWarning = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Column(
          children: [
             if(data.pan_no.toString().isEmpty) if(showPanWarning) Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: Row(children: [
                Expanded(child: Text(
                  "Please Add Pan Card Number in Profile So You Invest Upto 2 lacs",
                  style: Get.textTheme.caption
                      ?.copyWith(fontWeight: FontWeight.w500,color: Colors.black ),
                  textAlign: TextAlign.center,
                )),
                ElevatedButton(onPressed: (){}, child: Text("Add Pan"))
              ],),
            ),
            SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Current Available Balance",
                    style: Get.textTheme.caption?.copyWith(
                        fontWeight: FontWeight.w500, color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      AppConstant.rupeeSymbol + data.balance.toString(),
                      style: Get.textTheme.headline2
                          ?.copyWith(color: Colors.green[600]),
                    ),
                  ),
                  Text(
                    "Twelve thounsand only",
                    style: Get.textTheme.caption?.copyWith(
                        color: Colors.green[600], fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    "PAN No : - ${data.pan_no}",
                    style: Get.textTheme.subtitle1,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
