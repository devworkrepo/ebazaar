import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/matm_credo_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/data/repo_impl/matm_credo_impl.dart';
import 'package:spayindia/model/matm_credo/matm_credo_initiate.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

import '../../data/app_pref.dart';
import '../../data/repo/home_repo.dart';
import '../../service/native_call.dart';
import '../../util/security/encription.dart';

class MatmCredoController extends GetxController
    with LocationHelperMixin, TransactionHelperMixin {
  var formKey = GlobalKey<FormState>();
  var transactionTypeObs = MatmCredoTxnType.balanceEnquiry.obs;
  var mobileController = TextEditingController();
  var amountController = TextEditingController();
  var appPreference = Get.find<AppPreference>();

  MatmCredoRepo repo = Get.find<MatmCredoImpl>();
  HomeRepo homeRepo = Get.find<HomeRepoImpl>();

  MatmCredoInitiate? matmCredoInitiate;
  String? transactionNumber;

  var isMatm = true;

  var retryCount = 0;

  @override
  onInit() {
    super.onInit();
    transactionTypeObs.value =
        (isMatm) ? MatmCredoTxnType.microAtm : MatmCredoTxnType.mPos;
    position = null;
    validateLocation(progress: false);
  }

  getApiTransactionType() {
    switch (transactionTypeObs.value) {
      case MatmCredoTxnType.voidTxn:
        return "VOID";
      case MatmCredoTxnType.microAtm:
        return "CW";
      case MatmCredoTxnType.balanceEnquiry:
        return "BE";
      case MatmCredoTxnType.mPos:
        return "MPOS";
    }
  }

  onProceed() async {
    if (!formKey.currentState!.validate()) return;

    if (position == null) {
      await validateLocation();
      return;
    }

    try {
      StatusDialog.progress(title: "Initiating Transaction...");

      var txnRes = await homeRepo.getTransactionNumber();
      if (txnRes.code != 1) {
        StatusDialog.failure(title: txnRes.message);
        return;
      }
      transactionNumber = txnRes.transactionNumber;

      var amount = amountWithoutRupeeSymbol(amountController);
      if (transactionTypeObs.value == MatmCredoTxnType.balanceEnquiry) {
        amount = "0";
      }

      var response = await repo.initiateTransaction({
        "transaction_no": transactionNumber.toString(),
        "cust_mobile": mobileController.text,
        "txntype": getApiTransactionType(),
        "deviceid": await AppUtil.getDeviceID(),
        "amount": amount,
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      });

      Get.back();
      if (response.code == 1) {
        matmCredoInitiate = response;
        _startTransaction();
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  String getCredoPayTransactionType() {
    if (transactionTypeObs.value == MatmCredoTxnType.balanceEnquiry) {
      return "BE";
    } else if (transactionTypeObs.value == MatmCredoTxnType.microAtm) {
      return "MATM";
    } else if (transactionTypeObs.value == MatmCredoTxnType.mPos) {
      return "PURCHASE";
    } else if (transactionTypeObs.value == MatmCredoTxnType.voidTxn) {
      return "VOID";
    } else {
      return "";
    }
  }

  void _startTransaction() async {
    try {
      var decryptedPassword = Encryption.encryptCredopPayPassword(
          matmCredoInitiate!.loginPass.toString());
      var amount = amountWithoutRupeeSymbol(amountController);
      if (transactionTypeObs.value == MatmCredoTxnType.balanceEnquiry) {
        amount = "0";
      }
      var intAmount = int.parse(amount) * 100;

      var params = {
        "transactionType": getCredoPayTransactionType(),
        "debugMode": false,
        "production": true,
        "amount": intAmount,
        "loginId": matmCredoInitiate!.loginId.toString(),
        "password": decryptedPassword,
        "tid": matmCredoInitiate!.terminalid,
        "crnU": matmCredoInitiate!.transaction_no.toString(),
        "mobileNumber": mobileController.text,
      };
      var result = await NativeCall.credoPayService(params);
      _onTransactionResult(result);
    } catch (e) {
      _onTransactionResult(
          {"code": 2, "message": "Transaction Failure (exception)"});
    }
  }

  void _onTransactionResult(Map<dynamic, dynamic> result) async {
    AppUtil.logger("MatmCredopayResponse : $result");

    var status = 3;
    var clientId = matmCredoInitiate!.transaction_no;
    String? message = result["message"] ?? "";
    String? balanceAmount = result["accountBalance"] ?? "";
    String? cardNumber = result["maskedPan"] ?? "";
    String? bankRRN = result["rrn"] ?? "";
    String? bankName = result["cardApplicationName"] ?? "";
    String? transactionId = result["transactionId"] ?? "";

    if (transactionTypeObs.value == MatmCredoTxnType.balanceEnquiry) {
      status = result["code"];
    }

    int code = result["code"];
    if (code == 0) {
      String type = result["type"];
      if (type == "CHANGE_PASSWORD" ||
          type == "LOGIN_FAILED" ||
          type == "PASSWORD_CHANGE_FAILED") {
        if (retryCount < 2) {
          _startTransaction();
        } else {
          StatusDialog.failure(title: result["message"])
              .then((value) => Get.back());
        }
        retryCount++;
      }
    } else {
      try {
        StatusDialog.progress(title: "Updating...");
        await repo.updateMatmDataToServer({
          "status": status,
          "bankName": bankName,
          "cardNumber": cardNumber,
          "bankRRN": bankRRN,
          "message": message,
          "balanceamt": balanceAmount,
          "clientId": clientId,
          "providerTxnId": transactionId,
        });
        Get.back();
        Get.back();
      } catch (e) {
        Get.back();
        Get.back();
      }
    }
  }
}

enum MatmCredoTxnType { balanceEnquiry, microAtm, mPos, voidTxn }
