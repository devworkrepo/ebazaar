import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank_list.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/etns/on_string.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class AepsSettlementTransferController extends GetxController
    with TransactionHelperMixin {
  final AepsRepo repo = Get.find<AepsRepoImpl>();
  final AepsSettlementBank bank = Get.arguments["bank"];
  final amountController = TextEditingController();
  final mpinController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  void onProceed() {
    Get.dialog(AmountConfirmDialogWidget(
        amount: amountController.text.toString(),
        onConfirm: () {
          doSettlement();
        }));
  }

  void doSettlement() async {
    try {
      StatusDialog.progress();
      var param = {
        "unique_order_id": bank.id.orEmpty(),
        "account_number": bank.accountNumber.orEmpty(),
        "amount": amountWithoutRupeeSymbol(amountController),
        "transaction_pin": mpinController.text.toString(),
      };
      var response = await repo.settlementTransfer(param);
      Get.back();
      if (response.status == 1 || response.status == 34) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.back());
      } else {
        StatusDialog.failure(title: response.message);
      }

    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}
