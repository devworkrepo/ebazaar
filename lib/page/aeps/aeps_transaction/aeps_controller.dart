import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/page/aeps/aeps_transaction/aeps_page.dart';
import 'package:spayindia/page/aeps/widget/ekyc_info_widget.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/response/aeps/aeps_txn_response_page.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';
import 'package:spayindia/widget/common/confirm_amount_dialog.dart';
import 'package:spayindia/widget/dialog/aeps_rd_service_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/widget/list_component.dart';

import '../../../route/route_name.dart';
import '../../../util/mixin/location_helper_mixin.dart';

class AepsController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  bool isAadhaarPay = Get.arguments;

  var aepsBankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  var aepsFormKey = GlobalKey<FormState>();
  var aadhaarNumberController = TextEditingController();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();

  late List<AepsBank> bankList;

  AepsBank? selectedAepsBank;

  var aepsTransactionType = AepsTransactionType.cashWithdrawal.obs;

  late AepsBankResponse bankListResponse;

  getTitle() => isAadhaarPay ? "Aadhaar Pay" : "Aeps";

  @override
  void onInit() {
    super.onInit();
    _fetchBankList();
  }

  void _fetchBankList() async {
    try {
      aepsBankListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchAepsBankList();
      if (response.code == 1) {
        bankListResponse = response;
        bankList = response.aepsBankList!;
        aepsBankListResponseObs.value = Resource.onSuccess(response);
        if (!(response.isEKcy ?? false)) {
          showEkcyDialog("E-Kyc is Required.",
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
      else{
        validateLocation(progress: false);
      }
    } catch (e) {
      aepsBankListResponseObs.value = Resource.onFailure(e);
    }
  }

  void showEkcyDialog(String title, String message,String route) {
    Get.bottomSheet(
        EkycInfoWidget(
            title: title,
            message: message,
            onClick: () {
              Get.back();
              Get.offAndToNamed(route);
            },
            onCancel: () {
              Get.back();
              Get.back();
            }),
        isDismissible: false,
        persistent: false,
        enableDrag: false);
  }

  void onProceed() async {
    var isValidate = aepsFormKey.currentState!.validate();
    if (!isValidate) return;
    try {
      await validateLocation(progress: true);
      AppUtil.logger("Position : " + position.toString());
    } catch (e) {
      return;
    }

    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result = await NativeCall.launchAepsService(
              {"packageUrl": rdServicePackageUrl, "isTransaction": true});
          _onRdServiceResult(result);
        } on PlatformException catch (e) {
          StatusDialog.failure(title: "Fingerprint capture failed, please try again");

        } catch (e) {
          Get.to(() => ExceptionPage(error: e));
        }
      },
    ));
  }

  _onRdServiceResult(String data) async {
    var transactionType = "";
    if (aepsTransactionType.value == AepsTransactionType.cashWithdrawal ||
        isAadhaarPay) {
      transactionType = "Cash Withdrawal";
    } else if (aepsTransactionType.value ==
        AepsTransactionType.balanceEnquiry) {
      transactionType = "Balance Enquiry";
    }

    var isAmountNull = (isAadhaarPay ||
            aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
        ? false
        : true;

    Get.dialog(AmountConfirmDialogWidget(
        amount: (isAmountNull) ? null : amountController.text.toString(),
        detailWidget: [
          ListTitleValue(
              title: "Aadhaar No.",
              value: aadhaarNumberController.text.toString()),
          ListTitleValue(title: "Txn Type", value: transactionType),
          ListTitleValue(title: "Bank Name", value: selectedAepsBank?.name ?? ""),
        ],
        onConfirm: () {
          if(isAadhaarPay){
            _aadhaarPayTransaction(data);
          }
          else{
            _aepsTransaction(data);
          }
        }));
  }

  _aepsTransaction(String data) async {
    try {
      StatusDialog.transaction();
      var response = await repo.aepsTransaction(<String, String>{
        "bankiin": selectedAepsBank?.id ?? "",
        "bankName": selectedAepsBank?.name ?? "",
        "txntype": _transactionTypeInCode(),
        "devicetype": appPreference.rdService,
        "amount": (isAadhaarPay ||
                aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
            ? amountWithoutRupeeSymbol(amountController)
            : "0",
        "aadharno": aadhaarWithoutSymbol(aadhaarNumberController),
        "mobileno": mobileController.text.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
        "biometricData": data,
        "bcid": bankListResponse.bcid ?? "",
        "transaction_no": bankListResponse.transactionNumber ?? "",
        "deviceSerialNumber": await NativeCall.getRdSerialNumber(data),
      });
      Get.back();
      if (response.code == 1) {
        Get.to(() => AepsTxnResponsePage(), arguments: {
          "response": response,
          "aeps_type": aepsTransactionType.value,
          "isAadhaarPay": isAadhaarPay
        });
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.off(ExceptionPage(
        error: e,
      ));
    }
  }


  _aadhaarPayTransaction(String data) async {
    try {
      StatusDialog.transaction();
      var response = await repo.aadhaaPayTransaction(<String, String>{
        "bankiin": selectedAepsBank?.id ?? "",
        "bankName": selectedAepsBank?.name ?? "",
        "txntype": _transactionTypeInCode(),
        "devicetype": appPreference.rdService,
        "amount": (isAadhaarPay ||
            aepsTransactionType.value == AepsTransactionType.cashWithdrawal)
            ? amountWithoutRupeeSymbol(amountController)
            : "0",
        "aadharno": aadhaarWithoutSymbol(aadhaarNumberController),
        "mobileno": mobileController.text.toString(),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
        "biometricData": data,
        "bcid": bankListResponse.bcid ?? "",
        "transaction_no": bankListResponse.transactionNumber ?? "",
        "deviceSerialNumber": await NativeCall.getRdSerialNumber(data),
      });
      Get.back();
      if (response.code == 1) {
        Get.to(() => AepsTxnResponsePage(), arguments: {
          "response": response,
          "aeps_type": aepsTransactionType.value,
          "isAadhaarPay": isAadhaarPay
        });
      } else {
        StatusDialog.failure(title: response.message ?? "");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.off(ExceptionPage(
        error: e,
      ));
    }
  }

  _transactionTypeInCode() {

    switch(aepsTransactionType.value){
      case AepsTransactionType.cashWithdrawal:
        return "CW";
      case AepsTransactionType.balanceEnquiry:
        return "BE";
    }
  }

  @override
  void dispose() {
    aadhaarNumberController.dispose();
    mobileController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
