import 'package:get/get.dart';
import 'package:spayindia/data/repo/report_repo.dart';
import 'package:spayindia/data/repo_impl/report_impl.dart';
import 'package:spayindia/model/report/dmt.dart';
import 'package:spayindia/model/report/recharge.dart';
import 'package:spayindia/model/statement/credit_debit_statement.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/date_util.dart';
import 'package:spayindia/util/tags.dart';

import '../../../model/statement/account_statement.dart';

class CreditDebitController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchInput = "";

  var reportResponseObs = Resource
      .onInit(data: CreditDebitStatementResponse())
      .obs;
  late List<CreditDebitStatement> reportList;
  CreditDebitStatement? previousReport;

  final String tag;

  CreditDebitController(this.tag);

  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 30);
    toDate = DateUtil.currentDateInYyyyMmDd();
    fetchReport();
  }

  fetchReport() async {
    _param() =>
        {
          "fromdate": fromDate,
          "todate": toDate,
          "refno": searchInput,
        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = (tag == AppTag.creditStatementControllerTag)
          ? await repo.fetchCreditStatement(_param())
          : await repo.fetchDebitStatement(_param());
      if (response.code == 1) {
        reportList = response.reportList!;
      }
      reportResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      reportResponseObs.value = Resource.onFailure(e);
      Get.to(() => ExceptionPage(error: e));
    }
  }

  void swipeRefresh() {
    fromDate = DateUtil.currentDateInYyyyMmDd(dayBefore: 30);
    toDate = DateUtil.currentDateInYyyyMmDd();
    searchInput = "";
    fetchReport();
  }


  void onSearch() {
    fetchReport();
  }
}
