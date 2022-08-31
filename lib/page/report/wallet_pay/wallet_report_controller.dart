import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/report/summary/summary_wallet_pay.dart';
import 'package:spayindia/page/report/receipt_print_mixin.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/money_request_repo.dart';
import 'package:spayindia/data/repo_impl/money_request_impl.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/model/report/wallet.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_search/wallet_search_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';

import '../../../data/repo/report_repo.dart';

class WalletPayReportController extends GetxController with ReceiptPrintMixin {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";

  var reportResponseObs =
      Resource.onInit(data: WalletPayReportResponse()).obs;
  var reportList = <WalletPayReport>[].obs;
  Rx<SummaryWalletPayReport?> summaryReport = SummaryWalletPayReport().obs;

  WalletPayReport? previousReport;

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchReport();
    });
  }

  fetchSummaryReport() async{

    var response = await fetchSummary<SummaryWalletPayReport>({
      "fromdate": fromDate,
      "todate": toDate,
    }, ReportSummaryType.walletPay);
    summaryReport.value = response;


  }



  _fetchReport() async {
    fetchSummaryReport();
    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchWalletPayReport({
        "fromdate": fromDate,
        "todate": toDate,
      });
      if (response.code == 1) {
        reportList.value = response.reports!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    _fetchReport();
  }

  void onItemClick(WalletPayReport report) {
    if (previousReport == null) {
      report.isExpanded.value = true;
      previousReport = report;
    } else if (previousReport! == report) {
      report.isExpanded.value = !report.isExpanded.value;
      previousReport = null;
    } else {
      report.isExpanded.value = true;
      previousReport?.isExpanded.value = false;
      previousReport = report;
    }
  }

  void onSearch() {
    _fetchReport();
  }

}
