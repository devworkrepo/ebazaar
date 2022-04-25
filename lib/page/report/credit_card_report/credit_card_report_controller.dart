import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/report/credit_card.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/report/receipt_print_mixin.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';

import '../../../widget/dialog/status_dialog.dart';
import '../report_helper.dart';

class CreditCardReportController extends GetxController with ReceiptPrintMixin {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs = Resource.onInit(data: CreditCardReportResponse()).obs;
  late List<CreditCardReport> reportList;
  CreditCardReport? previousReport;

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
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
        reportList = response.reports!;
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
    searchStatus = "";
    searchInput = "";
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
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  void onSearch() {
    fetchReport();
  }
}
