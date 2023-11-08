
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/repo/money_request_repo.dart';
import 'package:ebazaar/data/repo_impl/money_request_impl.dart';
import 'package:ebazaar/service/native_call.dart';
import 'package:ebazaar/util/mixin/transaction_helper_mixin.dart';

class UpiPaymentController extends GetxController with TransactionHelperMixin {
  final MoneyRequestRepo repo = Get.find<MoneyRequestImpl>();
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();


  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {

    });
  }


  onSubmit() async {
    if (!formKey.currentState!.validate()) return;

    final result = await NativeCall.upiPayment({
      "amount" : "1",
      "refId" : "001001",
      "mobile" : "7982607742",
      "shopName" : "A. Communication"
    });

    Get.back();


  }



  @override
  void dispose() {
    amountController.removeListener(() {});
    super.dispose();
  }
}
