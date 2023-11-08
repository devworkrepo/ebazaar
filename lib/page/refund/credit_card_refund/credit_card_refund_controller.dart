import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ebazaar/widget/dialog/status_dialog.dart';
import 'package:ebazaar/data/repo/report_repo.dart';
import 'package:ebazaar/data/repo_impl/report_impl.dart';
import 'package:ebazaar/model/refund/credit_card.dart';
import 'package:ebazaar/model/refund/recharge.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/date_util.dart';

import '../../../util/security/encription.dart';

class CreditCardRefundController extends GetxController {
  ReportRepo repo = Get.find<ReportRepoImpl>();

  String fromDate = "";
  String toDate = "";
  String searchInput = "";

  var reportResponseObs =
      Resource.onInit(data: CreditRefundListResponse()).obs;
  late List<CreditCardRefund> reports;
  CreditCardRefund? previousReport;


  @override
  void onInit() {
    super.onInit();
    fromDate = DateUtil.currentDateInYyyyMmDd();
    toDate = DateUtil.currentDateInYyyyMmDd();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      fetchReport();
    });
  }

  void takeRefund(String mPin, CreditCardRefund report) async {
   try{
     StatusDialog.progress();
     var response = await repo.takeCreditCardRefund({
       "transaction_no": report.transactionNumber ?? "",
       "mpin":Encryption.encryptMPIN(mPin),
     });

     Get.back();
     if (response.code == 1) {
       StatusDialog.success(title: response.message)
           .then((value) => fetchReport());
     } else {
       StatusDialog.failure(title: response.message);
     }
   }catch(e){
     Get.back();
     Get.dialog(ExceptionPage(error: e));
   }
  }

  fetchReport() async {
    _param() => {
          "fromdate": fromDate,
          "todate": toDate,
          "transaction_no": searchInput,

        };

    try {
      reportResponseObs.value = const Resource.onInit();
      final response = await repo.creditCardRefundList(_param());
      if (response.code == 1) {
        reports = response.reports!;
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
    searchInput = "";
    fetchReport();
  }

  void onItemClick(CreditCardRefund report) {
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
