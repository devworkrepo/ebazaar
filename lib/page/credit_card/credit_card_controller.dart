import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/widget/common.dart';
import 'package:spayindia/widget/common/confirm_amount_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/widget/list_component.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/model/bank.dart';
import 'package:spayindia/model/recharge/credit_card.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../util/security/encription.dart';
import '../response/credit_card/credit_card_txn_response_page.dart';

class CreditCardController extends GetxController with TransactionHelperMixin, LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();
  var initialObs = Resource.onInit(data: CreditCardTypeResponse()).obs;

  AppPreference appPreference = Get.find();

  //form controllers
  var formKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  var mobileController = TextEditingController();
  var nameController = TextEditingController();
  var ifscCodeController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();
  var initialResponseFetchedObs = false.obs;
  var actionType = CreditCardActionType.fetch.obs;

  late List<Bank> bankList;
  late List<String> typeList;
  Bank? selectedBank;
  String selectedType = "";
  late CreditCardLimitResponse creditCardLimitResponse;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchInitialInfo();
      validateLocation(progress: false);
    });
  }

  _fetchInitialInfo() async {
    try {
      initialObs.value = const Resource.onInit();
      var bankResponse = await repo.fetchCreditCardBank();
      var typeResponse = await repo.fetchCreditCardType();

      bankList = bankResponse.banks;
      typeList = typeResponse.types!.map((e) => e.name ?? "").toList();

      typeResponse.bankResponse = bankResponse;
      initialObs.value = Resource.onSuccess(typeResponse);
    } catch (e) {
      initialObs.value = Resource.onFailure(e);
    }
  }

  onProceed() async {
    var isValidate = formKey.currentState!.validate();
    if (!isValidate) return;

    if (position == null) {
      await validateLocation();
      return;
    }

    if (actionType.value == CreditCardActionType.fetch) {
      _fetchCreditLimit();
    } else {
      Get.dialog(
          AmountConfirmDialogWidget(
              amount: amountController.text.toString(),
              detailWidget: [
                ListTitleValue(
                    title: "Card Number",
                    value: numberController.text.toString()),
                ListTitleValue(
                    title: "Mobile Number",
                    value: mobileController.text.toString()),
                ListTitleValue(title: "Card Type", value: selectedType),
                ListTitleValue(
                    title: "Bank Name", value: selectedBank?.bankName ?? ""),
                ListTitleValue(title: "User Name", value: nameController.text),
              ],
              onConfirm: () {
                _fetchTransactionNumber();
              }),
          barrierDismissible: false);
    }
  }

  _fetchTransactionNumber() async {
    try {
      StatusDialog.progress();
      var response = await repo.fetchTransactionNumber();
      Get.back();
      if (response.code == 1) {
        _makePayment(response.transactionNumber!);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _makePayment(String transactionNumber) async {
    try {
      cancelToken = CancelToken();
      StatusDialog.transaction();
      var param = {
        "transaction_no": transactionNumber,
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "amount": amountWithoutRupeeSymbol(amountController),
        "mobileno": mobileController.text,
        "cardno": aadhaarWithoutSymbol(numberController),
        "card_holdername": nameController.text,
        "card_type": selectedType,
        "bankname": selectedBank?.bankName ?? "",
        "ifsc": ifscCodeController.text,
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      };

      var response = await repo.makeCardPayment(param, cancelToken);
      Get.back();
      if (response.code == 1) {
        Get.to(() => CreditCardTxnResponsePage(),
            arguments: {"response": response});
      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!");
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  _fetchCreditLimit() async {
    try {
      StatusDialog.progress();
      var param = {
        "mobileno": mobileController.text,
        "cardno": aadhaarWithoutSymbol(numberController)
      };
      var response = await repo.fetchCreditLimit(param);
      Get.back();
      if (response.code == 1) {
        creditCardLimitResponse = response;
        actionType.value = CreditCardActionType.payment;
        showSuccessSnackbar(
            title: "Credit Limit", message: response.message ?? "");
      } else {
        showFailureSnackbar(
            title: "Credit Limit", message: response.message ?? "");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    amountController.dispose();
    nameController.dispose();
    ifscCodeController.dispose();
    mobileController.dispose();
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

enum CreditCardActionType { fetch, payment }
