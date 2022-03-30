import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/aeps_rd_service_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/component/list_component.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/aeps_bank.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/page/aeps/aeps_page.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/service/location.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

class AepsController extends GetxController with TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AppPreference appPreference = Get.find();

  bool isAadhaarPay = Get.arguments;

  var aepsBankListResponseObs = Resource.onInit(data: BankListResponse()).obs;

  var aepsFormKey = GlobalKey<FormState>();
  var aadhaarNumberController = TextEditingController();
  var mobileController = TextEditingController();
  var amountController = TextEditingController();

  late List<Bank> bankList;

  late Position position;

  Bank? selectedAepsBank;


  var aepsTransactionType = AepsTransactionType.cashWithdrawal.obs;

  getTitle()=> isAadhaarPay ? "Aadhaar Pay" : "Aeps";

  @override
  void onInit() {
    super.onInit();
    _fetchBankList();
  }

  void _fetchBankList() async {
    aepsBankListResponseObs.value = const Resource.onInit();
    try {
      BankListResponse response = await repo.fetchAepsBankList();
      aepsBankListResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      aepsBankListResponseObs.value = Resource.onFailure(e);
      Get.off(ExceptionPage(error: e));
    }
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
    if (aepsTransactionType.value == AepsTransactionType.cashWithdrawal) {
      transactionType = "Cash Withdrawal";
    } else if (aepsTransactionType.value == AepsTransactionType.miniStatement) {
      transactionType = "Mini Statement";
    } else if (aepsTransactionType.value == AepsTransactionType.balanceEquiry) {
      transactionType = "Balance Enquiry";
    }

    var isAmountNull =
        (aepsTransactionType.value == AepsTransactionType.balanceEquiry ||
                aepsTransactionType.value == AepsTransactionType.miniStatement)
            ? true
            : false;

    Get.dialog(AmountConfirmDialogWidget(
        amount: (isAmountNull) ? null : amountController.text.toString(),
        detailWidget: [
          ListTitleValue(
              title: "Aadhaar Number",
              value: aadhaarNumberController.text.toString()),
          ListTitleValue(title: "Transaction Type", value: transactionType),
          ListTitleValue(title: "Bank", value: selectedAepsBank?.bankName ?? ""),
        ],
        onConfirm: () {
          //todo remove and implement aeps transaction api
          showFailureSnackbar(title: "Coming soon", message: "work on progress");
          return;
          _aepsTransaction(data);
        }));
  }

  _aepsTransaction(String data) async {
    try {
      StatusDialog.transaction();
      var response = await repo.aepsTransaction(<String, String>{
        "IIN": selectedAepsBank?.ifscCode ?? "",
        "bank_name": selectedAepsBank?.bankName ?? "",
        "transaction_type": _transactionTypeInCode(),
        "device_name": appPreference.rdService,
        "amount": amountWithoutRupeeSymbol(amountController),
        "aadhaarNumber": aadhaarWithoutSymbol(aadhaarNumberController),
        "customer_number": mobileController.text.toString(),
        "latitude": position.latitude.toString(),
        "longitude": position.longitude.toString(),
        "txtPidData": data,
      });

      int status = response.status;
      if (status == 1 || status == 2 || status == 3) {
        Get.back();

      } else if (status == 34) {
        _checkStatus(response.orderId ?? "");
      } else {
        Get.back();
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      if (_transactionTypeInCode() == "CW" ||
          _transactionTypeInCode() == "AADHAAR_PAY") {
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

  var _checkStatusCount = 0;

  _checkStatus(String recordId) async {
    try {
      var response = await repo.checkStatus({"recordId": recordId});

      if (response.status == 11 && _checkStatusCount < 12) {
        await Future.delayed(const Duration(seconds: 5));
        _checkStatusCount++;
        _checkStatus(recordId);
      } else {
        Get.back();

      }

    }catch(e){
      Get.back();
      if (aepsTransactionType.value == AepsTransactionType.cashWithdrawal ||
          aepsTransactionType.value == AepsTransactionType.cashWithdrawal) {
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
      case AepsTransactionType.cashWithdrawal :
        return "CW";
      case AepsTransactionType.miniStatement :
        return "MS";
      case AepsTransactionType.balanceEquiry :
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
