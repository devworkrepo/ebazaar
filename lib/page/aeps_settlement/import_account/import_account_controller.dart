import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/dmt/beneficiary.dart';
import 'package:spayindia/model/dmt/response.dart';
import 'package:spayindia/model/dmt/sender_info.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';

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
