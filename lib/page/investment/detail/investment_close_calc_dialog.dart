import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/investment/Investment_close_calc.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_constant.dart';

class InvestmentCloseCalcDialog extends StatelessWidget {
  final InvestmentCloseCalcResponse response;
  const InvestmentCloseCalcDialog(this. response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 24,top: 16),
            child: Text("Investment Close Detail",style: Get.textTheme.subtitle1,),
          ),
          _BuildItem(title: "Amount", value: AppConstant.rupeeSymbol + response.balance.toString()),
          _BuildItem(title: "Charge", value: AppConstant.rupeeSymbol + response.charges.toString()),
          _BuildItem(title: "Close Type", value: response.closetype.toString()),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: SizedBox(
                height: 48,
                width: double.infinity,
                child:
                    ElevatedButton(onPressed: () {
                      Get.back();
                      Get.toNamed(AppRoute.investmentBankListPage);
                    }, child: Text("Proceed"))),
          )
        ],
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  final String title;
  final String value;

  const _BuildItem({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Text(
                    title,
                    style: Get.textTheme.subtitle2?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                        fontSize: 16),
                  )),
              Text("  :  "),
              Expanded(
                  flex: 3,
                  child: Text(
                    value,
                    style: Get.textTheme.subtitle2
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ],
          ),
        ),
        Divider(
          indent: 0,
          color: Colors.grey[300],
        )
      ],
    );
  }
}
