import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
import 'package:spayindia/widget/common/confirm_amount_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

import '../../model/aeps/aeps_bank.dart';
import '../../route/route_name.dart';
import '../../util/api/resource/resource.dart';
import '../../widget/list_component.dart';
import '../aeps/widget/ekyc_info_widget.dart';
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
  String? transactionNumber;
  MatmRequestResponse? requestResponse;
  bool updateToServerCalled = false;

  var aepsBankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  @override
  void onInit() {
    super.onInit();
    validateLocation(progress: false);
    _fetchBankList();
  }

  void _fetchBankList() async {
    try {
      aepsBankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchAepsBankList();
      if (response.code == 1) {

        aepsBankListResponseObs.value = Resource.onSuccess(response);
        if (!(response.isEKcy ?? false)) {
          showEkcyDialog("E-Kyc is Pending",
              "To do aeps, aadhaar pay and matm transaction E-Kyc is required!",AppRoute.aepsEkycPage);
        }
      } else if (response.code == 2) {
        showEkcyDialog(
          "OnBoarding Required",
          response.message ??
              "To do aeps, aadhaar pay and matm transaction"
                  " OnBoarding is required!",
          AppRoute.aepsOnboardingPage,
        );
      } else if (response.code == 3) {
        StatusDialog.pending(
            title: response.message ?? "Pending",
            buttonText: "Bank to Home")
            .then((value) => Get.back());
      }
    } catch (e) {
      aepsBankListResponseObs.value = Resource.onFailure(e);
    }
  }

  void showEkcyDialog(String title, String message,String route) {
    Get.bottomSheet(
        EkycInfoWidget(title : title, message : message,onClick: () {
          Get.back();
          Get.offAndToNamed(route);
        }, onCancel: () {
          Get.back();
          Get.back();
        }),
        isDismissible: false,
        persistent: false,
        enableDrag: false);
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
        amount: (transactionType.value == MatmTransactionType.cashWithdrawal)
            ? amountController.text
            : null,
        title: "Matm Transaction ? ",
        detailWidget: [
          ListTitleValue(title: "Mobile No.", value: mobileController.text),
          ListTitleValue(
              title: "Txn Type", value: getTransactionTypeInString()),
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
        transactionNumber ??= response.transactionNumber;
        if (requestResponse == null) {
          _initiateTransaction();
        }
      } else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  _initiateTransaction() async {
    try {
      requestResponse = await repo.initiateMatm({
        "transaction_no": transactionNumber,
        "cust_mobile": mobileController.text,
        "txntype": getSpayRequestTxnType(),
        "deviceid": await AppUtil.getDeviceID(),
        "amount": transactionType.value == MatmTransactionType.balanceEnquiry
            ? "0"
            : amountWithoutRupeeSymbol(amountController),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString()
      });
      Get.back();
      if (requestResponse!.code == 1) {
        Get.focusScope?.unfocus();
        _callMatmNativeMethod();
      } else {
        StatusDialog.failure(
            title: requestResponse!.message ?? "Not available");
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  _callMatmNativeMethod() async {
    try {
      var params = {
        "merchantUserId": requestResponse?.loginId ?? "",
        "merchantPassword": requestResponse?.loginPin ?? "",
        "superMerchantId": requestResponse?.superMerchantId ?? "",
        "amount": amountWithoutRupeeSymbol(amountController),
        "remark": "transaction",
        "mobileNumber": mobileController.text,
        "txnId": "tr${requestResponse?.txnId ?? ""}",
        "imei": await AppUtil.getDeviceID(),
        "latitude": position!.latitude,
        "longitude": position!.longitude,
        "type": _transactionTypeInCode(),
      };
      var result = await NativeCall.launchMatmService(params);
      var data = MatmResult.fromJson(result);
      if (!updateToServerCalled) {
        updateToServerCalled = true;
        _updateToServer(data);
      }
    } on PlatformException catch (e) {
      AppUtil.logger("matmlog1 : ${e.toString()}");
      StatusDialog.pending(
              title: "Transaction in Pending, please check transaction status")
          .then((value) => Get.back());
    } catch (e) {
      AppUtil.logger("matmlog2 : ${e.toString()}");
      StatusDialog.pending(
              title: "Transaction in Pending, please check transaction status")
          .then((value) => Get.back());
    }
  }

  _updateToServer(MatmResult result) async {
    StatusDialog.progress(title: "Updating to Server");
    try {
      await repo.updateMatmDataToServer({
        "status": "3" /*(result.status) ? "1" : "2"*/,
        "clientId": requestResponse!.clientId ?? "",
        "balanceamt": result.balAmount.toString(),
        "bankName": result.bankName,
        "cardNumber": result.cardNumber,
        "bankRRN": result.bankRrn,
        "message":"Transaction in pending", //result.message,
        "providerTxnId": requestResponse!.txnId ?? "",
      });
      Get.back();
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    } finally {
      Get.to(() => MatmTxnResponsePage(),
          arguments: {"response": result, "txnType": transactionType.value});
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
