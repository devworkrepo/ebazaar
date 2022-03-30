import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/recharge/recharge.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/util/app_util.dart';

class RechargeTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  RechargeResponse response = Get.arguments["response"];
  ProviderType provider = Get.arguments["type"];

  String getSvgImage(){
    if(provider == ProviderType.dth){
      return "assets/home/dth.svg";
    }
    else {
      return "assets/home/mobile.svg";
    }
  }

  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: "Recharge");
  }
}