import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/page/report/report_helper.dart';
import 'package:spayindia/page/response/paytm_wallet/paytm_wallet_txn_response_page.dart';

import '../../component/common.dart';
import '../../component/dialog/status_dialog.dart';
import '../../util/mixin/transaction_helper_mixin.dart';
import '../exception_page.dart';

class PaytmWalletController extends GetxController with TransactionHelperMixin {
  var mobileController = TextEditingController();
  var nameController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  RechargeRepo repo = Get.find<RechargeRepoImpl>();
  AppPreference appPreference = Get.find();

  var actionType = PaytmWalletLoadActionType.verify.obs;

  verify() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    String? transactionNumber = await fetchTransactionNumber();
    if (transactionNumber == null) {
      StatusDialog.failure(title: "Transaction Number is Required");
      return;
    }

    try {
      StatusDialog.progress();
      var response = await repo.verifyPaytmWallet({
        "transaction_no": transactionNumber,
        "mobileno": mobileController.text
      });
      Get.back();
      if (response.code == 1) {
        var statusCode = ReportHelperWidget.getStatusId(response.trans_status);
        if (statusCode == 1) {
          showSuccessSnackbar(
              title: "Paytm Wallet Info",
              message: response.trans_response ?? response.message ?? "");
          actionType.value = PaytmWalletLoadActionType.transaction;
        } else {
          StatusDialog.failure(title: response.trans_response ?? "");
        }
      } else {
        showFailureSnackbar(
            title: "Something went wrong", message: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  Future<String?> fetchTransactionNumber() async {
    try {
      StatusDialog.progress();
      var response = await repo.fetchTransactionNumber();
      Get.back();
      if (response.code == 1) {
        return response.transactionNumber;
      } else {
        showFailureSnackbar(
            title: "Something went wrong", message: response.message);
        return null;
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
      return null;
    }
  }

  withoutVerify() async {
    if (!formKey.currentState!.validate()) {
      return;
    }
    actionType.value = PaytmWalletLoadActionType.transaction;
  }

  onProceed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Get.dialog(AmountConfirmDialogWidget(
        amount: amountController.text,
        onConfirm: () {
          _loadPytmWallet();
        }));
  }

  _loadPytmWallet() async {
    try {
      await appPreference.setIsTransactionApi(true);
      String? transactionNumber = await fetchTransactionNumber();
      if (transactionNumber == null) {
        StatusDialog.failure(title: "Transaction Number is Required");
        return;
      }

      StatusDialog.transaction();
      var response = await repo.paymtWalletLoadTransaction({
        "mpin": mpinController.text,
        "transaction_no": transactionNumber,
        "mobileno": mobileController.text,
        "amount": amountWithoutRupeeSymbol(amountController)
      });
      Get.back();
      if (response.code == 1) {
        Get.to(() => PaytmWalletTxnResponsePage(),
            arguments: {"response": response});
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }
}

enum PaytmWalletLoadActionType { verify, transaction }
