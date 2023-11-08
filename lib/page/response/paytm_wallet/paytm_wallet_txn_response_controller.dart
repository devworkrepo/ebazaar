import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:ebazaar/model/paytm_wallet/paytm_wallet.dart';
import 'package:ebazaar/model/recharge/credit_card.dart';
import 'package:ebazaar/util/app_util.dart';

class PaytmWalletTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  PaytmLoadTransactionResponse response = Get.arguments["response"];


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: "Paytm Wallet");
  }
}
