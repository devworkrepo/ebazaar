import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spayindia/model/paytm_wallet/paytm_wallet.dart';
import 'package:spayindia/model/recharge/credit_card.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/util/app_util.dart';

class WalletLoadTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  WalletTransactionResponse response = Get.arguments["response"];


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: "Paytm Wallet");
  }
}
