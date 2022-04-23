import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/balance.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../../data/repo/aeps_repo.dart';

class AepsSettlementController extends GetxController
    with TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  var actionType = AepsSettlementType.spayAccount.obs;
  var amountController = TextEditingController();
  var remarkController = TextEditingController();

  var balanceResponseObs = Resource.onInit(data: AepsBalance()).obs;
  var bankResponseObs = Resource.onInit(data: BankListResponse()).obs;

  var formSpayAccount = GlobalKey<FormState>();
  var formBankAccount = GlobalKey<FormState>();

  AepsBalance? aepsBalance;
  List<Bank>? bankList;
  Bank? selectedBank;

  @override
  void onInit() {
    super.onInit();
    _fetchBalance();
  }

  _fetchBalance() async {
    ObsResponseHandler<AepsBalance>(
        obs: balanceResponseObs,
        apiCall: repo.fetchAepsBalance(),
        result: (data) {
          if (data.code == 1) {
            aepsBalance = data;
          }
        });
  }

  _fetchBank() async {
    ObsResponseHandler<BankListResponse>(
        obs: bankResponseObs,
        apiCall: repo.fetchAepsSettlementBank(),
        result: (data) {
          bankList = data.banks;
        });
  }

  @override
  void dispose() {
    amountController.dispose();
    remarkController.dispose();
    super.dispose();
  }

  onActionTypeChange(AepsSettlementType type) {
    if (aepsBalance != null) {
      actionType.value = type;

      if (actionType.value == AepsSettlementType.bankAccount) {
        if (bankList == null) _fetchBank();
      }
    }
  }

  onSpayAccountSettlement() async {
    if (!formSpayAccount.currentState!.validate()) return;
    Get.dialog(AmountConfirmDialogWidget(
      onConfirm: () {
        _transfer({
          "transaction_no": aepsBalance!.transaction_no.toString(),
          "amount": amountWithoutRupeeSymbol(amountController),
          "remark": remarkController.text,
        });
      },
      amount: amountController.text,
    ));
  }

  _transfer(Map<String, String> param) async {
    await appPreference.setIsTransactionApi(true);
    try {
      StatusDialog.transaction();

      var response = (actionType.value == AepsSettlementType.spayAccount)
          ? await repo.spayAccountSettlement(param)
          : await repo.bankAccountSettlement(param);
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message ?? "Success")
            .then((value) => Get.back());
      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!");
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  onBankSettlement() async {
    if (!formBankAccount.currentState!.validate()) return;
    Get.dialog(AmountConfirmDialogWidget(
      onConfirm: () {
        _transfer({
          "transaction_no": aepsBalance!.transaction_no.toString(),
          "amount": amountWithoutRupeeSymbol(amountController),
          "remark": remarkController.text,
          "bankid": selectedBank?.bankId ?? "",
        });
      },
      amount: amountController.text,
    ));
  }
}

enum AepsSettlementType { spayAccount, bankAccount }
