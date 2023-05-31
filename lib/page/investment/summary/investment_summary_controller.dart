import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/data/repo_impl/security_deposit_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/investment/investment_statement.dart';
import 'package:spayindia/model/investment/investment_summary.dart';
import 'package:spayindia/page/refund/credit_card_refund/credit_card_refund_controller.dart';
import 'package:spayindia/page/refund/credit_card_refund/credit_card_refund_page.dart';
import 'package:spayindia/page/refund/dmt_refund/dmt_refund_controller.dart';
import 'package:spayindia/page/refund/dmt_refund/dmt_refund_page.dart';
import 'package:spayindia/page/refund/recharge_refund/recharge_refund_controller.dart';
import 'package:spayindia/page/refund/recharge_refund/recharge_refund_page.dart';
import 'package:spayindia/page/refund/refund_tab.dart';
import 'package:spayindia/page/report/aeps_matm_report/aeps_matm_report_controller.dart';
import 'package:spayindia/page/report/aeps_matm_report/aeps_matm_report_page.dart';
import 'package:spayindia/page/report/credit_card_report/credit_card_report_controller.dart';
import 'package:spayindia/page/report/credit_card_report/credit_card_report_page.dart';
import 'package:spayindia/page/report/money_report/money_report_page.dart';
import 'package:spayindia/page/report/recharge_report/recharge_report_controller.dart';
import 'package:spayindia/page/report/recharge_report/recharge_report_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';


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
