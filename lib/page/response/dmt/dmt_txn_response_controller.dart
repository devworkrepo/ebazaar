import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/util/app_util.dart';

class DmtTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  DmtTransactionResponse dmtTransactionResponse = Get.arguments["response"];
  String totalAmount = Get.arguments["amount"];

  @override
  void onInit() {
    super.onInit();
  }

  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: totalAmount,
        type: "money transfer");
  }
}