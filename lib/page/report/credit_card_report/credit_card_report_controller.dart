import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/repo/report_repo.dart';
import 'package:ebazaar/data/repo_impl/report_impl.dart';
import 'package:ebazaar/model/report/credit_card.dart';
import 'package:ebazaar/model/report/summary/summary_credit_card.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/page/report/receipt_print_mixin.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/date_util.dart';

import '../../../widget/dialog/status_dialog.dart';
import '../report_helper.dart';

class CreditCardReportController extends GetxController with ReceiptPrintMixin {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  final String origin;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs = Resource.onInit(data: CreditCardReportResponse()).obs;
  var reportList = <CreditCardReport>[].obs;
  Rx<SummaryCreditCardReport?> summaryReport = SummaryCreditCardReport().obs;

  CreditCardReport? previousReport;

  CreditCardReportController(this.origin);

  @override
  void onInit() {
    super.onInit();
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  fetchSummaryReport() async {


    var response = await fetchSummary<SummaryCreditCardReport>({
      "fromdate": fromDate,
      "todate": toDate,
      "transaction_no": searchInput,
      "status": searchStatus,
    }, ReportSummaryType.creditCard);
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
      final response = await repo.fetchCreditCardReport(_param());
      if (response.code == 1) {
        reportList.value = response.reports!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchStatus = "";
    searchInput = "";
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
    fetchReport();
  }

  void onItemClick(CreditCardReport report) {
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

  void requeryTransaction(CreditCardReport report) async {
    try{
      StatusDialog.progress();
      var response =  await repo.requeryCreditCardTransaction({
        "transaction_no": report.transactionNumber ?? "",
      });

      Get.back();
      if (response.code == 1) {
        ReportHelperWidget.requeryStatus(response.trans_response ?? "InProgress",
            response.trans_response ?? "Message not found", () {
              fetchReport();
            });
      } else {
        StatusDialog.failure(title: response.message ?? "Something went wrong!!");
      }
    }catch(e){
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void onSearch() {
    fetchReport();
  }
}
