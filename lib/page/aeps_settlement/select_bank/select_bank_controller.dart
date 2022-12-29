import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/page/aeps_settlement/settlement/settlement_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

import '../../../widget/common/common_confirm_dialog.dart';
import '../../exception_page.dart';

class SelectSettlementBankController extends GetxController {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  var responseObs = Resource.onInit(data: AepsSettlementBankListResponse()).obs;
  var beneficiaryList = <AepsSettlementBank>[];
  RxList<AepsSettlementBank> beneficiaryListObs = <AepsSettlementBank>[].obs;

  var showSearchBoxObs = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchBankList();
    });
  }

  addNewBank(bool shouldPop) {
    if (shouldPop) {
      Get.offNamed(AppRoute.addSettlementBank, arguments: false);
    } else {
      Get.toNamed(AppRoute.addSettlementBank, arguments: true)?.then((value) {
        if (value) _fetchBankList();
      });
    }
  }

  _fetchBankList() async {

    try {
      responseObs.value = const Resource.onInit(data: null);
      var response = await repo.fetchAepsSettlementBank2();
        beneficiaryList = response.banks!;
        beneficiaryListObs.value = beneficiaryList;
      responseObs.value = Resource.onSuccess(response);

      if(response.code ==1 && response.banks!.isNotEmpty){
        showSearchBoxObs.value = true;
      }
      else {
        showSearchBoxObs.value = false;
      }
    } catch (e) {
      responseObs.value = Resource.onFailure(e);
      Get.off(ExceptionPage(error: e));
    }

  }

  onImportClick(){
    Get.toNamed(AppRoute.importSettlementBank)?.then((value) {
      if(value != null){
        if(value is bool && value == true){
          _fetchBankList();
        }
      }
    });
  }

  onTransferClick(AepsSettlementBank bank) {
    Get.toNamed(AppRoute.aepsSettlementPage, arguments: {
      "aeps_settlement_type": AepsSettlementType.bankAccount,
      "bank_account": bank
    });
  }

  onDeleteClick(AepsSettlementBank bank) {
    Get.dialog(CommonConfirmDialogWidget(
      onConfirm: () {
        _deleteBeneficiaryConfirm(bank);
      },
      title: "Confirm Delete",
      description: "You are sure! want to delete account ?",
    ));
  }

  void _deleteBeneficiaryConfirm(AepsSettlementBank bank) async {
    StatusDialog.progress(title: "Deleting...");
    try {

      var response = await repo.deleteBankAccount({
        "acc_id": bank.accountId.toString(),
      });
      Get.back();

      if(response.code ==1){
        StatusDialog.success(title: response.message).then((value) => _fetchBankList());
      }
      else {
        StatusDialog.alert(title: response.message);
      }

    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  onSearchChange(String value) {
    List<AepsSettlementBank> results = beneficiaryList;
    if (value.isEmpty) {
      results = beneficiaryList;
    } else {
      results = beneficiaryList
          .where((item) =>
      item.accountName!.toLowerCase().contains(value.toLowerCase()) ||
          item.accountNumber!.toLowerCase().contains(value.toLowerCase())||
          item.bankName!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    beneficiaryListObs.value = results;
  }
}
