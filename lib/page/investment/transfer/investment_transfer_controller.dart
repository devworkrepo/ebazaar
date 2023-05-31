import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/model/investment/Investment_close_calc.dart';
import 'package:spayindia/util/api/resource/resource.dart';

class InvestmentTransferController extends GetxController{

  AepsSettlementBank bank = Get.arguments["bank"]!;

  var calcObs = Resource.onInit(data: InvestmentCloseCalcResponse()).obs;
  TextEditingController mpinController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchCloseCalc();
    });
  }

  void fetchCloseCalc() async {

    calcObs.value = const Resource.onInit();
    await Future.delayed(const Duration(seconds: 2));
    var response = await repo.fetchCloseCalc({});
    calcObs.value  = Resource.onSuccess(response);

  }

}