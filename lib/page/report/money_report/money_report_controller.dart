import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/report/receipt_print_mixin.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/tags.dart';

import '../../../widget/dialog/status_dialog.dart';
import '../report_helper.dart';

class MoneyReportController extends GetxController with ReceiptPrintMixin {

  final String tag;
  final String origin;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var reportResponseObs = Resource.onInit(data: MoneyReportResponse()).obs;
  late List<MoneyReport> reportList;
  MoneyReport? previousReport;

  MoneyReportController(this.tag,this.origin);

  @override
  void onInit() {
    super.onInit();
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
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
      final response = (tag == AppTag.moneyReportControllerTag)
          ? await repo.fetchMoneyTransactionList(_param())
          : await repo.fetchPayoutTransactionList(_param());
      if (response.code == 1) {
        reportList = response.reports!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void requeryTransaction(MoneyReport report) async {
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
      ReportHelperWidget.requeryStatus(response.trans_response ?? "InProgress",
          response.trans_response ?? "Message not found", () {
        fetchReport();
      });
    } else {
      StatusDialog.failure(title: response.message ?? "Something went wrong");
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
