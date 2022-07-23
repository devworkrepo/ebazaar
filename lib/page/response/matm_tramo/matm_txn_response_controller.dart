import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:spayindia/model/aeps/aeps_transaction.dart';
import 'package:spayindia/model/matm/matm_request_response.dart';
import 'package:spayindia/page/aeps/aeps_transaction/aeps_page.dart';
import 'package:spayindia/util/app_util.dart';

import '../../matm_tramo/matm_page.dart';

class MatmTramoTxnResponseController extends GetxController {
  var screenshotController = ScreenshotController();
  MatmResult response = Get.arguments["response"];
  MatmTramoTransactionType type = Get.arguments["txnType"];



  String getTxnType(){
    if(type == MatmTramoTransactionType.cashWithdrawal){
      return "Cash Withdrawal";
    }
    else {
      return "Balance Enquiry";
    }
  }


  void captureAndShare() {
    AppUtil.captureAndShare(
        screenshotController: screenshotController,
        amount: response.transAmount.toString(),
        type: "Micro Atm");
  }
}
