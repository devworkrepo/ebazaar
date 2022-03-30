import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/service/location.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../component/list_component.dart';
import 'matm_page.dart';

class MatmController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  var matmFormKey = GlobalKey<FormState>();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();
  var transactionType = MatmTransactionType.cashWithdrawal.obs;

  @override
  void onInit() {
    super.onInit();
    validateLocation(progress: false);
  }

  void onProceed() async {
    var isValidate = matmFormKey.currentState!.validate();
    if (!isValidate) return;

    try {
      position = await LocationService.determinePosition();
      AppUtil.logger("Position : " + position.toString());
    } catch (e) {
      return;
    }

    Get.dialog(AmountConfirmDialogWidget(
        title: "Matm Transaction ? ",
        detailWidget: [
          ListTitleValue(title: "Mobile Number", value: mobileController.text),
          ListTitleValue(
              title: "Transaction Type", value: getTransactionTypeInString()),
        ],
        onConfirm: () {
          _callMatmNativeMethod();
        }));
  }

  _callMatmNativeMethod() async {
    try {
      var result = await NativeCall.launchMatmService({
        "merchantUserId": "1231",
        "merchantPassword": "12313",
        "superMerchantId": "13123",
        "amount": "100",
        "remark": "testing",
        "mobileNumber": "7982607742",
        "txnId": "tr1321",
        "imei": await AppUtil.getDeviceID(),
        "latitude": position!.latitude,
        "longitude": position!.longitude,
        "type": _transactionTypeInCode(),
      });

      AppUtil.logger("result : $result");
    } on PlatformException catch (e) {
      var description =
          "${(e.message) ?? "Capture failed, please try again! "} ${(e.details ?? "")}";

      Get.snackbar("Aeps Capture failed", description,
          backgroundColor: Colors.red, colorText: Colors.white);
    } catch (e) {
      AppUtil.logger("Exception : : " + e.toString());
    }
  }

  getTransactionTypeInString() {
    switch (transactionType.value) {
      case MatmTransactionType.cashWithdrawal:
        return "Cash Withdrawal";
      case MatmTransactionType.balanceEnquiry:
        return "Balance Enquiry";
    }
  }

  _transactionTypeInCode() {
    switch (transactionType.value) {
      case MatmTransactionType.cashWithdrawal:
        return 2;
      case MatmTransactionType.balanceEnquiry:
        return 4;
    }
  }

  @override
  void dispose() {
    mobileController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
