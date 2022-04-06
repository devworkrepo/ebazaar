import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/model/dmt/beneficiary.dart';
import 'package:spayindia/model/dmt/calculate_charge.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/dmt/sender_info.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/response/dmt/dmt_txn_response_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class DmtTransactionController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AppPreference appPreference = Get.find();

  DmtRepo repo = Get.find<DmtRepoImpl>();

  SenderInfo sender = Get.arguments["sender"];
  Beneficiary beneficiary = Get.arguments["beneficiary"];

  DmtType dmtType = Get.arguments["dmtType"];

  var transactionChargeWidgetVisibilityObs = false.obs;

  var calculateChargeResponseObs =
      Resource.onInit(data: CalculateChargeResponse()).obs;
  late CalculateChargeResponse calculateChargeResponse;

  var formKey = GlobalKey<FormState>();
  var mpinController = TextEditingController();
  var remarkController = TextEditingController();

  DmtTransferType transferType = Get.arguments["type"];
  String amount = Get.arguments["amount"];
  String isView = Get.arguments["isView"];

  @override
  void onInit() {
    super.onInit();
    validateLocation(progress: false);
    _calculateTransactionCharge();
  }

  void onProceed() async {
    if (!formKey.currentState!.validate()) return;
    _confirmDialog();
  }

  _confirmDialog() {
    var widgetList = <ListTitleValue>[];

    widgetList = [
        ListTitleValue(title: "Name", value: beneficiary.name ?? ""),
        ListTitleValue(
            title: "A/C No.", value: beneficiary.accountNumber ?? ""),
        ListTitleValue(title: "Bank", value: beneficiary.bankName ?? ""),
        ListTitleValue(title: "IFSc", value: beneficiary.ifscCode ?? ""),
      ];

    Get.dialog(AmountConfirmDialogWidget(
        amount: amount,
        detailWidget: widgetList,
        onConfirm: () {

            _dmtTransfer();

        }));
  }


  _dmtTransfer() async {
    var value = checkBalance(appPreference.user.availableBalance, amount);
    if (!value) return;
    if (!(await validateLocation())) return;
    await appPreference.setIsTransactionApi(true);

    try {
      StatusDialog.transaction();

      DmtTransactionResponse response;

      switch (dmtType) {
        case DmtType.instantPay:
          if ((sender.isKycVerified ?? false)) {
            response = await repo.kycTransaction(_transactionParam());
          } else {
            response = await repo.nonKycTransaction(_transactionParam());
          }
          break;
        case DmtType.payout:
          response = await repo.payoutTransaction(_transactionParam());
          break;
      }

      Get.back();

      if (response.code == 0) {
        StatusDialog.failure(title: response.message);
      } else {
        Get.to(() => DmtTxnResponsePage(), arguments: {
          "response": response,
          "amount" : amount,
          "dmtType" : dmtType
        });
      }

    } catch (e) {
      Get.back();
      Get.off(() => ExceptionPage(error: e,));
    }
  }

  _transactionParam() => {
        "beneid": beneficiary.id ?? "",
        "transfer_amt": amount,
        "mpin": mpinController.text,
        "remark": remarkController.text,
        "calcid": calculateChargeResponse.calcId.toString(),
        "trans_type": (transferType == DmtTransferType.imps) ? "IMPS" : "NEFT"
      };

  _calculateTransactionCharge() async {
    try {
      var param = <String, String>{
        "remitter_mobile": sender.senderNumber.toString(),
        "beneid": beneficiary.id.toString(),
        "isview": isView,
        "trans_type": (transferType == DmtTransferType.imps) ? "IMPS" : "NEFT",
        "amount": amount,
        "sessionkey": appPreference.sessionKey,
        "dvckey": await AppUtil.getDeviceID()
      };

      calculateChargeResponseObs.value = const Resource.onInit();
      CalculateChargeResponse response;

      if (dmtType == DmtType.instantPay) {
        if (sender.isKycVerified!) {
          response = await repo.calculateKycCharge(param);
        } else {
          response = await repo.calculateNonKycCharge(param);
        }
      } else {
        response = await repo.calculatePayoutCharge(param);
      }

      calculateChargeResponse = response;
      calculateChargeResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      calculateChargeResponseObs.value = Resource.onFailure(e);
      Get.to(() => () => ExceptionPage(error: e));
    }
  }

  void setTransactionChargeWidgetVisibility() {
    transactionChargeWidgetVisibilityObs.value =
        !transactionChargeWidgetVisibilityObs.value;
  }

  @override
  void dispose() {
    mpinController.dispose();
    remarkController.dispose();
    super.dispose();
  }
}
