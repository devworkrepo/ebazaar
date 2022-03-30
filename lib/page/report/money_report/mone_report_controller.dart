import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/money_request_repo.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/money_request_impl.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/fund/request_report.dart';
import 'package:spayindia/model/report/ledger.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';

class MoneyReportController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";

  var moneyReportResponseObs =
       Resource.onInit(data: MoneyReportResponse()).obs;
  late List<MoneyReport> moneyReportList;
  MoneyReport? previousReport;

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
   // _fetchReport();
  }

  fetchReport() async {
    try {
      moneyReportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchMoneyTransactionList({
        "fromdate": fromDate,
        "todate": toDate,
        "requestno": searchInput,
        "status": searchStatus,
      });
      if (response.code == 1) {
        moneyReportList = response.reports!;
      }
      moneyReportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      moneyReportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    searchStatus = "";
    searchInput = "";
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
