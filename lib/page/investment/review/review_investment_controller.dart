import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/investment/inventment_balance.dart';
import 'package:spayindia/model/investment/inventment_calc.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class ReviewInvestmentController extends GetxController{
  TextEditingController pinController = TextEditingController();

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();
  InvestmentBalanceResponse balance = Get.arguments["balance"]!;
  InvestmentCalcResponse calc = Get.arguments["calc"]!;
  String tenureType= Get.arguments["tenureType"]!;
  String tenureDuration= Get.arguments["tenureDuration"]!;
  String amount = Get.arguments["amount"]!;
  @override
  void onInit() {

    super.onInit();

    var a = calc.intamt.toString();

  }

  void onSubmit() async {
    var mpin = pinController.text.toString();
    if(mpin.length > 3 && mpin.length < 7 ){

      StatusDialog.progress(title: "Proceeding...");
      CommonResponse response = await repo.createInvestment({
        "investamt" : amount,
        "durationtype" : tenureType,
        "durationvalue" : tenureDuration,
      });
      Get.back();

      if(response.code ==1){
        StatusDialog.success(title: response.message).then((value) => Get.offAllNamed(AppRoute.mainPage));
      }
      else {
        StatusDialog.alert(title: response.message);
      }


    }
    else {
      StatusDialog.alert(title: "Enter valid mpni");
    }
  }

}