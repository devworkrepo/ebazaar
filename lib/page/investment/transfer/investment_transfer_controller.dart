import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/investment/Investment_close_calc.dart';
import 'package:spayindia/model/investment/investment_list.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class InvestmentTransferController extends GetxController{

  AepsSettlementBank bank = Get.arguments["bank"]!;

  var calcObs = Resource.onInit(data: InvestmentCloseCalcResponse()).obs;
  late InvestmentCloseCalcResponse calc;
  TextEditingController mpinController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();
  InvestmentListItem item = Get.arguments["item"];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchCloseCalc();
    });
  }

  void fetchCloseCalc() async {

    calcObs.value = const Resource.onInit();
    var response = await repo.fetchCloseCalc({
      "fdid" : item.fdid.toString()
    });
    calc = response;
    calcObs.value  = Resource.onSuccess(response);

  }

  void onSubmit() async {
    var isValid = formKey.currentState!.validate();
    if(!isValid){
      return;
    }

    StatusDialog.progress();

    CommonResponse response = await repo.closeInvestment({
      "transaction_no" :calc.trans_no.toString() ,
      "fdid" : item.fdid.toString(),
      "acc_id" : bank.accountId.toString(),
      "amount" : calc.balance.toString(),
      "charges" : calc.charges.toString(),
      "closedtype" : calc.closetype.toString(),
      "mpin" : mpinController.text.toString(),
      "remark" : remarkController.text.toString(),
    });

    Get.back();

    if(response.code ==1){
      StatusDialog.success(title:response.message).then((value) => Get.offAllNamed(AppRoute.mainPage));
    }
    else {
      StatusDialog.alert(title: response.message);
    }


  }

}