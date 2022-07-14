import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/radio.dart';
import 'package:spayindia/widget/text_field.dart';

enum _TestTransactionType {
  microAtm,
  balanceEnquiry,
  purchase,
  voidTransaction,
  cashAtPos,
  upi,
}

class _TestCredoController extends GetxController {
  var transactionTypeObs = _TestTransactionType.balanceEnquiry.obs;
  var crnUController = TextEditingController();
  var resultController = TextEditingController();

  var retryCount = 0;

  String getTransactionType() {
    if (transactionTypeObs.value == _TestTransactionType.balanceEnquiry) {
      return "BE";
    } else if (transactionTypeObs.value == _TestTransactionType.microAtm) {
      return "MATM";
    } else if (transactionTypeObs.value == _TestTransactionType.purchase) {
      return "PURCHASE";
    } else if (transactionTypeObs.value ==
        _TestTransactionType.voidTransaction) {
      return "VOID";
    } else if (transactionTypeObs.value == _TestTransactionType.upi) {
      return "UPI";
    } else {
      return "CASH_AT_POS";
    }
  }
}

class TestCredoPayPage extends GetView<_TestCredoController> {
  const TestCredoPayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(_TestCredoController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("CredoPay"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  "Credo Pay",
                  style: Get.textTheme.headline5,
                ),
                Card(
                  child: Obx(() => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            AppRadioButton(
                                groupValue: controller.transactionTypeObs.value,
                                value: _TestTransactionType.balanceEnquiry,
                                title: "Balance Enquiry",
                                onChange: (_TestTransactionType value) {
                                  controller.transactionTypeObs.value = value;
                                }),
                            AppRadioButton(
                                groupValue: controller.transactionTypeObs.value,
                                value: _TestTransactionType.microAtm,
                                title: "Micro Atm",
                                onChange: (_TestTransactionType value) {
                                  controller.transactionTypeObs.value = value;
                                }),
                            AppRadioButton(
                                groupValue: controller.transactionTypeObs.value,
                                value: _TestTransactionType.purchase,
                                title: "Purchase",
                                onChange: (_TestTransactionType value) {
                                  controller.transactionTypeObs.value = value;
                                }),
                            AppRadioButton(
                                groupValue: controller.transactionTypeObs.value,
                                value: _TestTransactionType.voidTransaction,
                                title: "Void Transaction",
                                onChange: (_TestTransactionType value) {
                                  controller.transactionTypeObs.value = value;
                                }),
                            AppRadioButton(
                                groupValue: controller.transactionTypeObs.value,
                                value: _TestTransactionType.cashAtPos,
                                title: "Cash At Pos",
                                onChange: (_TestTransactionType value) {
                                  controller.transactionTypeObs.value = value;
                                }),
                            AppRadioButton(
                                groupValue: controller.transactionTypeObs.value,
                                value: _TestTransactionType.upi,
                                title: "UPI",
                                onChange: (_TestTransactionType value) {
                                  controller.transactionTypeObs.value = value;
                                }),
                            AppTextField(
                              controller: controller.crnUController,
                              inputType: TextInputType.number,
                              label: "Crn Number",
                            ),
                            AppTextField(
                              controller: controller.resultController,
                              label: "Result",
                            )
                          ],
                        ),
                      )),
                ),
                AppButton(
                    text: "Launch",
                    onClick: () {
                      _startTransaction();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startTransaction() async {
    try {
      /*var params = {
        "transactionType": controller.getTransactionType(),
        "debugMode": false,
        "production": true,
        "amount": 100,
        "loginId": "2000005429",
        "password": "d9%dhTrzzx",
        "tid": "E0022603",
        "crnU": controller.crnUController.text,
        "mobileNumber": "7982607742",
      };*/

      var params = {
        "transactionType": controller.getTransactionType(),
        "debugMode": false,
        "production": true,
        "amount": 100,
        "loginId": "2000021001",
        "password": "4Sge!vryku",
        "tid": "E0058713",
        "crnU": controller.crnUController.text,
        "mobileNumber": "7982607742",
      };

      var result = await NativeCall.credoPayService(params);
      AppUtil.logger("credopay_result : $result");
      controller.resultController.text = result.toString();
      _onTransactionResult(result);
    } catch (e) {
      AppUtil.logger("CredoPayError : ${e.toString()}");
      controller.resultController.text = "Exception : " + e.toString();
    }
  }

  void _onTransactionResult(Map<dynamic, dynamic> result) async {
    int code = result["code"];
    if (code == 4) {
      String type = result["type"];
      if (type == "CHANGE_PASSWORD" ||
          type == "LOGIN_FAILED" ||
          type == "PASSWORD_CHANGE_FAILED") {
          if (controller.retryCount < 2){
            _startTransaction();
          }
          controller.retryCount++;

          AppUtil.logger("retry count : ${controller.retryCount}");

      }
    }
  }
}
