import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/investment/inventment_balance.dart';
import 'package:spayindia/model/investment/inventment_calc.dart';

class ReviewInvestmentController extends GetxController{
  TextEditingController pinController = TextEditingController();

  InvestmentBalanceResponse balance = Get.arguments["balance"]!;
  InvestmentCalcResponse calc = Get.arguments["calc"]!;
  String tenure = Get.arguments["tenure"]!;
  String amount = Get.arguments["amount"]!;
  @override
  void onInit() {

    super.onInit();

    var a = calc.intamt.toString();

  }

}