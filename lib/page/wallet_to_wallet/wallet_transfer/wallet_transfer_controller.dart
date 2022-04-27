import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/response/wallet_load/wallet_load_txn_response_page.dart';
import 'package:spayindia/widget/common/confirm_amount_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/wallet_repo.dart';
import 'package:spayindia/data/repo_impl/wallet_repo_impl.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class WalletTransferController extends GetxController with TransactionHelperMixin {
  WalletSearchResponse data = Get.arguments;
  WalletRepo repo = Get.find<WalletRepoImpl>();

  AppPreference appPreference = Get.find();

  var amountController = TextEditingController();
  var remarkController = TextEditingController();
  var mpinController = TextEditingController();
  var isFavouriteChecked = true.obs;
  var formKey = GlobalKey<FormState>();

  onProceed() async {
    if (!formKey.currentState!.validate()) return;
    Get.dialog(AmountConfirmDialogWidget(onConfirm: (){
      _transfer();
    },amount: amountController.text,));

  }

  _transfer() async {
    try {
      StatusDialog.transaction();
      var response = await repo.walletTransfer({
        "transaction_no" : data.transactionNumber!,
        "agentid" : data.agentId!,
        "amount" : amountWithoutRupeeSymbol(amountController),
        "remark" : remarkController.text,
        "mpin" : mpinController.text,
        "isfav" : isFavouriteChecked.value.toString(),
      });

      Get.back();

      if(response.code == 1){
        response.amount = amountWithoutRupeeSymbol(amountController);
        response.outletName = data.outletName;
        response.agentName = data.agentName;
        Get.to(()=>WalletLoadTxnResponsePage(),arguments: {
          "response" : response
        });
      }
      else {
        StatusDialog.failure(title:  response.message);
      }

    } catch (e) {
      appPreference.setIsTransactionApi(true);
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}

