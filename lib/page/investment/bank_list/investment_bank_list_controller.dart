import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';

class InvestmentBankListController extends GetxController{

  AepsRepo repo = Get.find<AepsRepoImpl>();
  var responseObs = Resource.onInit(data: AepsSettlementBankListResponse()).obs;
  AepsSettlementBank? previousBank;
  var buttonText = "".obs;

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