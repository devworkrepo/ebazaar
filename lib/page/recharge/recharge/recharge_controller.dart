import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/util/mixin/location_helper_mixin.dart';
import 'package:ebazaar/widget/common/confirm_amount_dialog.dart';
import 'package:ebazaar/widget/dialog/status_dialog.dart';
import 'package:ebazaar/widget/list_component.dart';
import 'package:ebazaar/data/app_pref.dart';
import 'package:ebazaar/data/repo/recharge_repo.dart';
import 'package:ebazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:ebazaar/model/recharge/provider.dart';
import 'package:ebazaar/model/recharge/recharge.dart';
import 'package:ebazaar/model/recharge/response.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/page/main/home/home_controller.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/mixin/transaction_helper_mixin.dart';

import '../../../util/security/encription.dart';
import '../../response/recharge/recharge_txn_response_page.dart';

class RechargeController extends GetxController
    with TransactionHelperMixin, LocationHelperMixin {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  Map<String, dynamic> argument = Get.arguments;

  AppPreference appPreference = Get.find();

  late Provider provider;
  late String providerImage;
  late String providerName;
  late ProviderType providerType;
  late String transactionNumber;

  //form controllers
  var rechargeFormKey = GlobalKey<FormState>();
  var numberController = TextEditingController();
  var amountController = TextEditingController();
  var mpinController = TextEditingController();

  var circleResponseObs = Resource.onInit(data: RechargeCircleResponse()).obs;
  late List<RechargeCircle> circleList;

  String amount = "";
  String number = "";

  late RechargeCircle circle;

  @override
  void onInit() {
    super.onInit();

    provider = argument["provider"];
    providerImage = argument["provider_image"];
    providerName = argument["provider_name"];
    providerType = argument["provider_type"];
    transactionNumber = argument["transactionNumber"];

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchCircles();
    });
  }

  _fetchCircles() async {
    try {
      circleResponseObs.value = const Resource.onInit();
      var response = await repo.fetchCircles({});
      circleList = response.circles!;
      circleResponseObs.value = Resource.onSuccess(response);

      validateLocation(progress: false);
    } catch (e) {
      circleResponseObs.value = Resource.onFailure(e);
    }
  }

  onProceed() async {
    var isValidate = rechargeFormKey.currentState!.validate();
    if (!isValidate) return;

    if (position == null) {
      await validateLocation();
      return;
    }

    Get.dialog(
        AmountConfirmDialogWidget(
            amount: amountController.text.toString(),
            detailWidget: [
              ListTitleValue(
                  title: "Number", value: numberController.text.toString()),
              ListTitleValue(title: "Provider", value: provider.name),
            ],
            onConfirm: () {
              _makeMobileRecharge();
            }),
        barrierDismissible: false);
  }

  _makeMobileRecharge() async {
    StatusDialog.transaction();
    try {
      cancelToken = CancelToken();

      RechargeResponse response = (providerType == ProviderType.dth)
          ? await repo.makeDthRecharge(_transactionParam(), cancelToken)
          : (providerType == ProviderType.prepaid)
              ? await repo.makeMobilePrepaidRecharge(
                  _transactionParam(), cancelToken)
              : await repo.makeMobilePostpaidRecharge(
                  _transactionParam(), cancelToken);

      Get.back();

      if (response.code == 1) {
        Get.to(RechargeTxnResponsePage(),
            arguments: {"response": response, "type": providerType});
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      await appPreference.setIsTransactionApi(true);
      Get.back();
      Get.dialog(
         ExceptionPage(
          error: e,
          data: {
            "param": _transactionParam(),
            "transaction_type": "Recharge : ${provider.name.toString()}"
          },
        ),
      );
    }
  }

  _transactionParam() => {
        "mpin": Encryption.encryptMPIN(mpinController.text),
        "transaction_no": transactionNumber,
        "operatorid": provider.id.toString(),
        "operatorname": provider.name.toString(),
        "circleid": circle.id.toString(),
        "circlename": circle.name.toString(),
        "mobileno": numberController.text.toString(),
        "amount": amountWithoutRupeeSymbol(amountController),
        "latitude": position!.latitude.toString(),
        "longitude": position!.longitude.toString(),
      };

  String getNumberLabel() {
    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid) {
      return "Mobile Number";
    } else if (providerType == ProviderType.dth) {
      return "Customer Id";
    }
    return "";
  }

  String getNumberHintText() {
    if (providerType == ProviderType.prepaid) {
      return "Enter 10 digit prepaid mobile number";
    }
    if (providerType == ProviderType.postpaid) {
      return "Enter 10 digit postpaid mobile number";
    } else if (providerType == ProviderType.dth) {
      return "Enter 6 - 14 digits Customer Id";
    }
    return "";
  }

  numberValidation(String? value) {
    if (providerType == ProviderType.postpaid ||
        providerType == ProviderType.prepaid) {
      if (value!.length == 10) {
        return null;
      } else {
        return "Enter 10 digits mobile number";
      }
    } else if (providerType == ProviderType.dth) {
      if (value!.length > 5 && value.length < 15) {
        return null;
      } else {
        return "Enter valid 6 - 14 digits Customer Id";
      }
    } else {
      return "Provider Type not valid";
    }
  }

  getMaxLength() {
    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid) {
      return 10;
    } else if (providerType == ProviderType.dth) {
      return 14;
    } else {
      return 20;
    }
  }

  @override
  void dispose() {
    numberController.dispose();
    amountController.dispose();
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
