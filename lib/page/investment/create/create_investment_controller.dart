import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/investment/inventment_balance.dart';
import 'package:spayindia/model/investment/inventment_calc.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class CreateInvestmentController extends GetxController with TransactionHelperMixin{
  TextEditingController amountController = TextEditingController();
  TextEditingController tenureController = TextEditingController();

  late InvestmentBalanceResponse balance;
  var tenureType = "Days";
  var isAgree = false;

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();
  var responseObs = Resource.onInit(data: InvestmentBalanceResponse()).obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchInvestmentBalance();
    });
  }

  _fetchInvestmentBalance() async{

    ObsResponseHandler(obs: responseObs, apiCall: repo.fetchInvestmentBalance());

  }

  onSubmit() async{
    var strAmount = amountWithoutRupeeSymbol(amountController);
    if(strAmount.isEmpty) strAmount = "0";

    var strTenure = tenureController.text.toString();
    if(strTenure.isEmpty) strTenure = "0";

    var amount = int.parse(strAmount);
    var tenure = int.parse(strTenure);

    if(amount < 1){
      StatusDialog.alert(title: "Enter valid amount!");
      return;
    }
    if(tenure < 1){
      StatusDialog.alert(title: "Enter valid tenure!");
      return;
    }
    if(!isAgree){
      StatusDialog.alert(title: "Need to agree terms and conditions for further process!");
      return;
    }

    _fetchCalc(amount.toString(),tenure.toString());

  }

  _fetchCalc(String amount,String tenure) async{
    StatusDialog.progress(title: "Fetching Detail...");
    await Future.delayed(Duration(seconds: 2));
    InvestmentCalcResponse response = await repo.fetchInvestmentCalc({
      "investamt" : amount,
      "durationtype" : tenureType,
      "durationvalue" : tenure,

    });
    Get.back();
    if(response.code ==1){
      Get.toNamed(AppRoute.reviewInvestmentPage,arguments: {
        "balance" : balance,
        "calc" : response,
        "amount" : amount.toString(),
        "tenure" : tenure + " "+tenureType
      });
    }
    else {
      StatusDialog.alert(title: response.message);
    }


  }
}