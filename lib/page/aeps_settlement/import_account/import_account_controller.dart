import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/repo/aeps_repo.dart';
import 'package:ebazaar/data/repo_impl/aeps_repo_impl.dart';
import 'package:ebazaar/model/aeps/settlement/bank.dart';
import 'package:ebazaar/widget/dialog/status_dialog.dart';
import 'package:ebazaar/data/repo/dmt_repo.dart';
import 'package:ebazaar/data/repo_impl/dmt_repo_impl.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/dmt/beneficiary.dart';
import 'package:ebazaar/model/dmt/response.dart';
import 'package:ebazaar/model/dmt/sender_info.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/future_util.dart';

import '../../dmt/import_beneficiary/common.dart';

class ImportSettlementAccountController extends GetxController {
  AepsRepo repo = Get.find<AepsRepoImpl>();

  late List<AepsSettlementBank> beneficiaryList;
  var selectedListObs = <AepsSettlementBank>[].obs;
  var responseObs = Resource.onInit(data: AepsSettlementBankListResponse()).obs;

  @override
  void onInit() {
    super.onInit();
    _searchDeletedBeneficiary();
  }

  _searchDeletedBeneficiary() async {
    try {
      obsResponseHandler<AepsSettlementBankListResponse>(
          obs: responseObs,
          apiCall: repo.deletedBankLists({}),
          onResponse: (value) {
            beneficiaryList = value.banks!;
          });
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  void importBeneficiaries() async {
    StatusDialog.progress(title: "Importing...");
    try {

      var ids = "";
      for(int i =0;i<selectedListObs.length;i++){
        if(i ==0){
          ids = selectedListObs[i].accountId.toString();
        }
        else{
          ids = ids + ","+selectedListObs[i].accountId.toString();
        }
      }

      var response = await repo.importDeletedAepsBank({
        "acc_ids": ids,
      });
      Get.back();
      if(response.code == 1){
        StatusDialog.success(title: response.message).then((value) => Get.back(result: true));
      }
      else {
        StatusDialog.alert(title: response.message);
      }

    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}
