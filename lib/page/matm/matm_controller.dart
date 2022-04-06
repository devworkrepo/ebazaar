import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/matm/matm_request_response.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/service/location.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../component/list_component.dart';
import '../response/matm/matm_txn_response_page.dart';
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
          _getTransactionNumber();
        }));
  }

  _getTransactionNumber() async {
    try {
      StatusDialog.progress(title: "Initiating Transaction...");
      var response = await repo.getMamtTransactionNumber();

      if (response.code == 1) {
        _initiateTransaction(response.transactionNumber!);
      } else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  _initiateTransaction(String transactionNumber) async {
    try {
      var response = await repo.initiateMatm({
        "transaction_no": transactionNumber,
        "cust_mobile": mobileController.text,
        "txntype": getSpayRequestTxnType(),
        "deviceid": await AppUtil.getDeviceID(),
        "amount": amountWithoutRupeeSymbol(amountController),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString()
      });
      Get.back();
      if (response.code == 1) {
        _callMatmNativeMethod(response);
      } else {
        StatusDialog.failure(title: response.message ?? "Not available");
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  _callMatmNativeMethod(MatmRequestResponse response) async {
    try {

      var params = {
        "merchantUserId": response.loginId ?? "",
        "merchantPassword": response.loginPin ?? "",
        "superMerchantId": response.superMerchantId ?? "",
        "amount": amountWithoutRupeeSymbol(amountController),
        "remark": "transaction",
        "mobileNumber": mobileController.text,
        "txnId": "tr${response.txnId ?? ""}",
        "imei": await AppUtil.getDeviceID(),
        "latitude": position!.latitude,
        "longitude": position!.longitude,
        "type": _transactionTypeInCode(),
      };
      var result = await NativeCall.launchMatmService(params);

      AppUtil.logger("params : $params");
      AppUtil.logger(result);

      var data = MatmResult.fromJson(result);
      Get.to(()=>MatmTxnResponsePage(),arguments: {
        "response" : data,
        "txnType" : transactionType.value
      });



    } on PlatformException catch (e) {

      AppUtil.logger("matmlog1 : ${e.toString()}");

      /*StatusDialog.pending(
              title: "Transaction in Pending, please check transaction status")
          .then((value) => Get.back());*/
    } catch (e) {
      AppUtil.logger("matmlog2 : ${e.toString()}");
     /* StatusDialog.pending(
          title: "Transaction in Pending, please check transaction status")
          .then((value) => Get.back());*/
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

  getSpayRequestTxnType() {
    switch (transactionType.value) {
      case MatmTransactionType.cashWithdrawal:
        return "CW";
      case MatmTransactionType.balanceEnquiry:
        return "BE";
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
