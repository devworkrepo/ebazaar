import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/model/recharge/response.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/response/bill_payment/bill_payment_txn_response_page.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class LicOnlineController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  AppPreference appPreference = Get.find();

  var actionType = LicOnlineActionType.fetchBill.obs;

  var billFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var policyNumberController = TextEditingController();
  var emailController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();

  late BillInfoResponse billInfoResponse;

  var strDueDate = "";

  onProceed() {
    if (!_validateForFetchBill()) return;
    if (actionType.value == LicOnlineActionType.fetchBill) {
      _fetchBillInfo();
    } else {
      _confirmBillPayDialog();
    }
  }

  bool _validateForFetchBill() {
    var isValidate = billFormKey.currentState!.validate();
    if (!isValidate) return false;
    return true;
  }

  _confirmBillPayDialog() async {
    var value = checkBalance(appPreference.user.availableBalance,
        amountWithoutRupeeSymbol(amountController));
    if (!value) return;
    if (!(await validateLocation())) return;

    Get.dialog(
        AmountConfirmDialogWidget(
            isDecimal: true,
            amount: amountController.text.toString(),
            detailWidget: [
              ListTitleValue(
                  title: "Number",
                  value: policyNumberController.text.toString()),
              ListTitleValue(title: "Provider", value: "LIC Premium"),
            ],
            onConfirm: () {
              _makeBillPayment();
            }),
        barrierDismissible: false);
  }

  _paymentParam() => <String, String>{
        "transaction_no": billInfoResponse.transactionNumber ?? "",
        "name": billInfoResponse.name ?? "",
        "mobileno": mobileNumberController.text,
        "amount": amountWithoutRupeeSymbol(amountController),
        "policyno": policyNumberController.text,
        "emailid": emailController.text,
        "mpin": mpinController.text,
      };

  _makeBillPayment() async {
    var validBalance = checkBalance(appPreference.user.availableBalance,
        amountWithoutRupeeSymbol(amountController));
    if (!validBalance) return;


    StatusDialog.transaction();
    try {
      cancelToken = CancelToken();
      await appPreference.setIsTransactionApi(true);
      var response =
          await repo.makeLicOnlineBillPayment(_paymentParam(), cancelToken);
      Get.back();
      if (response.code == 1) {
        Get.to(()=>BillPaymentTxnResponsePage(),arguments: {
          "response" : response
        });
      } else {
        StatusDialog.failure(title: response.message ?? "message not found");
      }
    } catch (e) {
      AppUtil.logger('Transaction Exception : ${e.toString()}');
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  _fetchBillInfo() async {
    try {
      StatusDialog.progress(title: "Fetching");

      BillInfoResponse response = await repo.fetchLicBillInfo({
        "policyno": policyNumberController.text,
        "mobileno": mobileNumberController.text,
        "emailid": emailController.text,
      });
      Get.back();

      if (response.code == 1) {
        Get.snackbar("Bill Info", response.message ?? "Something went wrong!",
            backgroundColor: Colors.green, colorText: Colors.white);
        billInfoResponse = response;
        actionType.value = LicOnlineActionType.payBill;
        amountController.text = "₹ " + response.amount!;
      } else {
        Get.snackbar("Bill Info", response.message ?? "Something went wrong!",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }
  }

  getButtonText() {
    return (actionType.value == LicOnlineActionType.fetchBill)
        ? "Fetch Bill Info"
        : "Pay Bill";
  }

  isFieldEnable() {
    return actionType.value == LicOnlineActionType.fetchBill;
  }

  isAmountEnable() {
    return billInfoResponse.isPart;
  }

  @override
  void dispose() {
    policyNumberController.dispose();
    amountController.dispose();
    mobileNumberController.dispose();
    mpinController.dispose();
    if (cancelToken != null) {
      if (!(cancelToken?.isCancelled ?? false)) {
        cancelToken
            ?.cancel("Transaction was initiate but didn't catch response");
      }
    }
    super.dispose();
  }
}

enum LicOnlineActionType { fetchBill, payBill }
