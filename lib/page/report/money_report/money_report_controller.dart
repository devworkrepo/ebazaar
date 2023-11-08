import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:ebazaar/data/repo/report_repo.dart';
import 'package:ebazaar/data/repo_impl/report_impl.dart';
import 'package:ebazaar/model/report/dmt.dart';
import 'package:ebazaar/model/report/summary/summary_dmt_utility.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/page/report/receipt_print_mixin.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/date_util.dart';
import 'package:ebazaar/util/tags.dart';

import 'package:ebazaar/widget/dialog/status_dialog.dart';
import 'package:ebazaar/page/report/report_helper.dart';

class MoneyReportController extends GetxController with ReceiptPrintMixin {
  final String tag;
  final String origin;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs = Resource.onInit(data: MoneyReportResponse()).obs;
  var reportList = <MoneyReport>[].obs;
  MoneyReport? previousReport;
  Rx<SummaryDmtUtilityReport?> summaryReport = SummaryDmtUtilityReport().obs;

  MoneyReportController(this.tag, this.origin);

  @override
  void onInit() {
    super.onInit();
    if (origin == "summary") {
      searchStatus = "InProgress";
    }
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  fetchSummaryReport() async {
    ReportSummaryType type;
    if (tag == AppTag.payoutReportControllerTag) {
      type = ReportSummaryType.payout;
    } else {
      type = ReportSummaryType.dmt;
    }

    var response = await fetchSummary<SummaryDmtUtilityReport>({
      "fromdate": fromDate,
      "todate": toDate,
      "transaction_no": searchInput,
      "status": searchStatus,
    }, type);
    summaryReport.value = response;
  }

  fetchReport() async {
    fetchSummaryReport();
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,
          "status": searchStatus,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.moneyReportControllerTag)
          ? await repo.fetchMoneyTransactionList(_param())
          : await repo.fetchPayoutTransactionList(_param());
      if (response.code == 1) {
        reportList.value = response.reports!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void requeryTransaction(MoneyReport report) async {
    try {
      StatusDialog.progress();
      var response = (tag == AppTag.moneyReportControllerTag)
          ? await repo.requeryDmtTransaction({
              "transaction_no": report.transactionNumber ?? "",
            })
          : await repo.requeryPayoutTransaction({
              "transaction_no": report.transactionNumber ?? "",
            });

      Get.back();
      if (response.code == 1) {
        ReportHelperWidget.requeryStatus(
            response.trans_response ?? "InProgress",
            response.trans_response ?? "Message not found", () {
          fetchReport();
        });
      } else {
        StatusDialog.failure(title: response.message ?? "Something went wrong");
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
    searchInput = "";
    if (origin == "summary") {
      searchStatus = "InProgress";
    }
    fetchReport();
  }

  void onItemClick(MoneyReport report) {
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
    fetchReport();
  }
}
