import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/repo/aeps_repo.dart';
import 'package:ebazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:ebazaar/model/aeps/settlement/bank.dart';
import 'package:ebazaar/model/investment/investment_list.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/future_util.dart';

class InvestmentBankListController extends GetxController{

  AepsRepo repo = Get.find<AepsRepoImpl>();
  var responseObs = Resource.onInit(data: AepsSettlementBankListResponse()).obs;
  AepsSettlementBank? previousBank;
  var buttonText = "".obs;
  bool fromHome = Get.arguments["origin"] ?? false;
  InvestmentListItem? item = Get.arguments["item"];

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchBankList();
    });
  }

  _fetchBankList() async {
    ObsResponseHandler<AepsSettlementBankListResponse>(
        obs: responseObs,
        apiCall: repo.fetchAepsSettlementBank2(),
        result: (data) {
          if (data.code == 2) {

          }
        });
  }

  onItemClick(AepsSettlementBank bank) {
    if(fromHome) return;
    if (previousBank == null) {
      bank.isSelected.value = true;
      previousBank = bank;
      buttonText.value = "TRANSFER TO ${bank.bankName}";
    } else if (previousBank! == bank) {
      bank.isSelected.value = !bank.isSelected.value;
      previousBank = null;
      buttonText.value = "";
    } else {
      bank.isSelected.value = true;
      previousBank?.isSelected.value = false;
      previousBank = bank;
      buttonText.value = "TRANSFER TO ${bank.bankName}";
    }
  }
}