import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/aeps_rd_service_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/page/aeps/aeps_transaction/aeps_page.dart';
import 'package:spayindia/page/aeps/widget/ekyc_info_widget.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/response/aeps/aeps_txn_response_page.dart';
import 'package:spayindia/service/location.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../../route/route_name.dart';

class AepsController extends GetxController with TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  bool isAadhaarPay = Get.arguments;

  var aepsBankListResponseObs = Resource.onInit(data: AepsBankResponse()).obs;

  var aepsFormKey = GlobalKey<FormState>();
  var aadhaarNumberController = TextEditingController();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();

  late List<AepsBank> bankList;

  late Position position;

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
    obsResponseHandler<AepsBankResponse>(
        obs: aepsBankListResponseObs,
        apiCall: repo.fetchAepsBankList(),
        onResponse: (data) {
          if (data.code == 1) {
            bankListResponse = data;
            bankList = data.aepsBankList!;
            if (!data.isEKcy!) {
              Get.bottomSheet(
                  EkycInfoWidget(onClick: () {
                    Get.back();
                    Get.offAndToNamed(RouteName.aepsEkycPage);
                  }, onCancel: () {
                    Get.back();
                    Get.back();
                  }),
                  isDismissible: false,
                  persistent: false,
                  enableDrag: false);
            }
          }
        });
  }

  void onProceed() async {
    var isValidate = aepsFormKey.currentState!.validate();
    if (!isValidate) return;
    try{
      position = await LocationService.determinePosition();
      AppUtil.logger("Position : "+position.toString());
    }catch(e){
      return;
    }


    Get.dialog(AepsRdServiceDialog(
      onClick: (rdServicePackageUrl) async {
        try {
          var result =
              await NativeCall.launchAepsService({"packageUrl": rdServicePackageUrl});
          _onRdServiceResult(result);
        } on PlatformException catch (e) {
          var description =
              "${(e.message) ?? "Capture failed, please try again! "} ${(e.details ?? "")}";

          Get.snackbar("Aeps Capture failed", description,
              backgroundColor: Colors.red, colorText: Colors.white);
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
          _aepsTransaction(data);
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
        "amount": amountWithoutRupeeSymbol(amountController),
        "aadharno": aadhaarWithoutSymbol(aadhaarNumberController),
        "mobileno": mobileController.text.toString(),
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
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
      Get.back();
      if (aepsTransactionType.value == AepsTransactionType.cashWithdrawal ||
          isAadhaarPay) {
        await appPreference.setIsTransactionApi(true);
        Get.back();
        Get.off(ExceptionPage(
          error: e,
        ));
      } else {
        Get.back();
        Get.to(() => ExceptionPage(error: e));
      }
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
