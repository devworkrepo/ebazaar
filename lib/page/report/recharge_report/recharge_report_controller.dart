import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/model/report/recharge.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/report/receipt_print_mixin.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';

class RechargeReportController extends GetxController with ReceiptPrintMixin{
  ReportRepo repo = Get.find<ReportRepoImpl>();

  final String origin;
  String fromDate = "";
  String toDate = "";
  String searchStatus = "";
  String searchInput = "";
  String rechargeType = "";

  var reportResponseObs = Resource.onInit(data: RechargeReportResponse()).obs;
  late List<RechargeReport> reportList;
  RechargeReport? previousReport;

  RechargeReportController(this.origin);

  @override
  void onInit() {
    super.onInit();
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchRechargeValue();
    fetchReport();
  }

  fetchRechargeValue() async {
    repo.rechargeValues();
  }

  fetchReport() async {
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,
          "status": searchStatus,
          "rech_type": rechargeType,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.fetchRechargeTransactionList(_param());
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
    rechargeType="";
    if(origin ==  "summary"){
      searchStatus = "InProgress";
    }
    fetchReport();
  }

  void onItemClick(RechargeReport report) {
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
