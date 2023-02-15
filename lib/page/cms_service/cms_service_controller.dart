
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo/money_request_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/data/repo_impl/money_request_impl.dart';
import 'package:spayindia/model/cms_service.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../data/repo/home_repo.dart';
import '../../util/api/resource/resource.dart';

class CMSServiceController extends GetxController with TransactionHelperMixin {
  final HomeRepo repo = Get.find<HomeRepoImpl>();

  var cmsServiceResponseObs = Resource.onInit(data: CmsServiceResponse()).obs;
  late WebViewController webViewController;

  var redirectUrl = "".obs;

  @override
  onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _fetchRedirectUrl();
    });
  }

  _fetchRedirectUrl() async{
    try {
      cmsServiceResponseObs.value = const Resource.onInit();
      final response =
      await repo.cmsService();
      cmsServiceResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      cmsServiceResponseObs.value = Resource.onFailure(e);
    }
  }

  void onProceed(String redirectUrl) {
    this.redirectUrl.value = redirectUrl;
  }


}

