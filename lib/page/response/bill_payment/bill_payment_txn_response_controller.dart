import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/recharge/bill_payment.dart';
import 'package:spayindia/model/recharge/recharge.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/util/app_util.dart';

class BillPaymentTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  BillPaymentResponse response = Get.arguments["response"];
  ProviderType? provider = Get.arguments["type"];

  String getSvgImage(){
    if(provider == ProviderType.electricity){
      return "assets/svg/electricity.svg";
    }
    if(provider == ProviderType.water){
      return "assets/svg/water.svg";
    }
    if(provider == ProviderType.gas){
      return "assets/svg/gas.svg";
    }
    if(provider == ProviderType.landline){
      return "assets/svg/landline.svg";
    }
    else {
      return "assets/svg/electricity.svg";
    }
  }

  String getPngImage(){
    return "assets/image/lic.png";
  }


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.amount.toString(),
        type: (response.billerName?.toLowerCase() ?? "") + "Payment");
  }
}