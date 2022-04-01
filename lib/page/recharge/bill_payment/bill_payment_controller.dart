import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/model/recharge/extram_param.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/recharge/response.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/page/recharge/provider/provider_controller.dart';
import 'package:spayindia/page/response/bill_payment/bill_payment_txn_response_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class BillPaymentController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  Map<String, dynamic> argument = Get.arguments;

  AppPreference appPreference = Get.find();

  var actionType = BillPaymentActionType.fetchBill.obs;

  late Provider provider;
  late String providerImage;
  late String providerName;
  late ProviderType providerType;

  //form controllers
  var billFormKey = GlobalKey<FormState>();
  var mobileNumberController = TextEditingController();
  var fieldOneController = TextEditingController();
  var fieldTwoController = TextEditingController();
  var fieldThreeController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();

  var extraParamResponseObs =
      Resource.onInit(data: BillExtraParamResponse()).obs;
  late BillExtraParamResponse extraParam;
  late BillInfoResponse billInfoResponse;

  var strDueDate = "";
  var billContext = "";

  @override
  void onInit() {
    super.onInit();

    provider = argument["provider"];
    providerImage = argument["provider_image"];
    providerName = argument["provider_name"];
    providerType = argument["provider_type"];


    _fetchExtraParam();
  }

  _fetchExtraParam() async {
    extraParamResponseObs.value = const Resource.onInit();

    try {
      var response = await repo.fetchExtraParam({
        "operatorid": provider.id,
        "cattype": getProviderInfo(providerType)?.requestParam ?? ""
      });
      if (response.code == 1) {

        if(providerType == ProviderType.insurance){
          response.field1 = "Policy Number";
          response.field2 = "Date of Birth";
          response.field3 = "Email ID";
        }
        extraParam = response;
        extraParamResponseObs.value = Resource.onSuccess(response);
      } else {
        throw "Extra param status was not success! please contact with admin";
      }
    } catch (e) {
      extraParamResponseObs.value = Resource.onFailure(e);
      Get.off(ExceptionPage(error: e));
    }
  }

  onProceed() {
    if (!_validateForFetchBill()) return;
    if (actionType.value == BillPaymentActionType.fetchBill) {
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



  _confirmBillPayDialog() {
    var value = checkBalance(appPreference.user.availableBalance,
        amountWithoutRupeeSymbol(amountController));
    if (!value) return;

    Get.dialog(
        AmountConfirmDialogWidget(
            isDecimal: true,
            amount: amountController.text.toString(),
            detailWidget: [
              ListTitleValue(
                  title: "Number", value: fieldOneController.text.toString()),
              ListTitleValue(title: "Provider", value: provider.name),
            ],
            onConfirm: () {
              _makeBillPayment();
            }),
        barrierDismissible: false);
  }

  _paymentParam() => <String, String>{
        "transaction_no": billInfoResponse.transactionNumber ?? "",
        "cattype": getProviderInfo(providerType)?.requestParam ?? "",
        "operatorid": provider.id,
        "operatorcode": provider.operatorCode,
        "operatorname": provider.name,
        "customername": billInfoResponse.name ?? "",
        "mobileno": mobileNumberController.text,
        "amount": amountWithoutRupeeSymbol(amountController),
        "field1": fieldOneController.text,
        "field2": fieldTwoController.text,
        "field3": fieldThreeController.text,
        "mpin": mpinController.text,
      };

  _makeBillPayment() async {
    var validBalance = checkBalance(appPreference.user.availableBalance,
        amountWithoutRupeeSymbol(amountController));
    if (!validBalance) return;
    if (!(await validateLocation())) return;

    StatusDialog.transaction();
    try {
      await appPreference.setIsTransactionApi(true);
      var response = (billInfoResponse.isPart ?? false)
          ? await repo.makePartBillPayment(_paymentParam())
          : await repo.makeOfflineBillPayment(_paymentParam());
      Get.back();
      if (response.code == 1) {
        Get.to(() => BillPaymentTxnResponsePage(),
            arguments: {"response": response, "type": providerType});
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

      BillInfoResponse response = await repo.fetchBillInfo({
        "field1": fieldOneController.text,
        "field2": fieldTwoController.text,
        "field3": fieldThreeController.text,
        "mobileno": mobileNumberController.text,
        "operatorid": provider.id.toString(),
        "transaction_no": extraParam.transactionNumber ?? "",
        "cattype": getProviderInfo(providerType)?.requestParam ?? "",
      });
      Get.back();

      if (response.code == 1) {
        Get.snackbar("Bill Info", response.message ?? "Something went wrong!", backgroundColor: Colors.green, colorText: Colors.white);
        billInfoResponse = response;
        actionType.value = BillPaymentActionType.payBill;


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
    return (actionType.value == BillPaymentActionType.fetchBill)
        ? "Fetch Bill Info"
        : "Pay Bill";
  }

  isFieldEnable(){
    return actionType.value == BillPaymentActionType.fetchBill;
  }

  isAmountEnable(){
   return  billInfoResponse.isPart;
  }

  @override
  void dispose() {
    fieldOneController.dispose();
    amountController.dispose();
    mobileNumberController.dispose();
    fieldTwoController.dispose();
    fieldThreeController.dispose();
    mpinController.dispose();
    super.dispose();
  }
}

enum BillPaymentActionType { fetchBill, payBill }
