import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/app_pref.dart';
import 'package:ebazaar/data/repo/home_repo.dart';
import 'package:ebazaar/data/repo/security_deposit_repo.dart';
import 'package:ebazaar/data/repo_impl/home_repo_impl.dart';
import 'package:ebazaar/data/repo_impl/security_deposit_impl.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/investment/investment_statement.dart';
import 'package:ebazaar/model/investment/investment_summary.dart';
import 'package:ebazaar/page/refund/credit_card_refund/credit_card_refund_controller.dart';
import 'package:ebazaar/page/refund/credit_card_refund/credit_card_refund_page.dart';
import 'package:ebazaar/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:ebazaar/page/refund/dmt_refund/dmt_refund_page.dart';
import 'package:ebazaar/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:ebazaar/page/refund/recharge_refund/recharge_refund_page.dart';
import 'package:ebazaar/page/refund/refund_tab.dart';
import 'package:ebazaar/page/report/aeps_matm_report/aeps_matm_report_controller.dart';
import 'package:ebazaar/page/report/aeps_matm_report/aeps_matm_report_page.dart';
import 'package:ebazaar/page/report/credit_card_report/credit_card_report_controller.dart';
import 'package:ebazaar/page/report/credit_card_report/credit_card_report_page.dart';
import 'package:ebazaar/page/report/money_report/money_report_page.dart';
import 'package:ebazaar/page/report/recharge_report/recharge_report_controller.dart';
import 'package:ebazaar/page/report/recharge_report/recharge_report_page.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/future_util.dart';


class InvestmentSummaryController extends GetxController {

  SecurityDepositRepo repo = Get.find<SecurityDepositImpl>();

  var responseObs = Resource.onInit(data: InvestmentSummaryResponse()).obs;


  AppPreference appPreference = Get.find();

  @override
  onInit(){
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchSummary();
    });
  }


  fetchSummary() async {
    ObsResponseHandler<InvestmentSummaryResponse>(
        obs: responseObs,
        apiCall: repo.fetchSummary());
  }


}
