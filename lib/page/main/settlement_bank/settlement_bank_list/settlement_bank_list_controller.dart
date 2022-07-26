import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/aeps/settlement/bank.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/widget/common.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class SettlementBankListController extends GetxController {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  var responseObs = Resource.onInit(data: AepsSettlementBankListResponse()).obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchBankList();
    });
  }

  addNewBank(bool shouldPop) {
    if (shouldPop) {
      Get.offNamed(AppRoute.addSettlementBank, arguments: false);
    } else {
      Get.toNamed(AppRoute.addSettlementBank, arguments: true)?.then((value) {
        if (value) _fetchBankList();
      });
    }
  }

  _fetchBankList() async {
    ObsResponseHandler<AepsSettlementBankListResponse>(
        obs: responseObs,
        apiCall: repo.fetchAepsSettlementBank2(),
        result: (data) {
          if (data.code == 2) {
            addNewBank(true);
          }
        });
  }

  Future downloadFile(AepsSettlementBank bank) async {
    Get.find<HomeRepoImpl>().downloadFileAndSaveToGallery(
        AppConstant.requestImageBaseUrl, bank.cancelCheque!);
  }
}
