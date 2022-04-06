import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/page/aeps/aeps_transaction/aeps_page.dart';
import 'package:spayindia/util/app_util.dart';

class AepsTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  AepsTransactionResponse response = Get.arguments["response"];
  AepsTransactionType aepsTransactionType = Get.arguments["aeps_type"];
  bool isAadhaarPay = Get.arguments["isAadhaarPay"];

  String getTitle() {
    if (isAadhaarPay) {
      return "Aadhaar Pay";
    } else {
      return "AEPS";
    }
  }

  String getSubTitle() {
    if (isAadhaarPay) {
      return "Cash Withdrawal";
    } else {
      switch (aepsTransactionType) {
        case AepsTransactionType.cashWithdrawal:
          return "Cash Withdrawal";
        case AepsTransactionType.balanceEnquiry:
          return "Balance Enquiry";
      }
    }
  }

  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: getTitle());
  }
}
