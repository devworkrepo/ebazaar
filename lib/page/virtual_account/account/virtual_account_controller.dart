import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/virtual_account_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/data/repo_impl/virtual_account_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/virtual_account/virtual_account.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/widget/image.dart';

class VirtualAccountController extends GetxController  {
  VirtualAccountRepo repo = Get.find<VirtualAccountImpl>();
  var responseObs = Resource.onInit(data: VirtualAccountDetailResponse()).obs;

  AppPreference appPreference = Get.find();

  @override
  void onInit() {
    super.onInit();
    _fetchAccounts();
  }

  _fetchAccounts() async {
    ObsResponseHandler(obs: responseObs, apiCall: repo.fetchVirtualAccounts());
  }

  addNewVirtualAccount(VirtualAccountCreationType type) async {
    try {
      StatusDialog.progress();
      var response = (type == VirtualAccountCreationType.yesBank)
          ? await repo.addYesVirtualAccount()
          : await repo.addIciciVirtualAccount();
      Get.back();
      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => _fetchAccounts());
      } else {
        StatusDialog.failure(title: response.message)
            .then((value) => _fetchAccounts());
      }
    } catch (e) {
      Get.back();
      Get.to(() => ExceptionPage(error: e));
    }

    if (type == VirtualAccountCreationType.yesBank) {
    } else if (type == VirtualAccountCreationType.iciciBank) {}
  }

  showQRCode(YesBankVirtualAccount account) {
    Get.dialog(Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 64),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppNetworkImage(
                AppConstant.qrCodeBaseUrl + account.qr_img!,
                size: Get.width,
              ),
            ),
            Text(
              "UPI",
              style: Get.textTheme.subtitle1
                  ?.copyWith(color: Get.theme.primaryColor),
            ),
            Text(
              account.upi_id!,
              style: Get.textTheme.subtitle1
                  ?.copyWith(color: Get.theme.primaryColor),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
                onPressed: () {
                  Get.find<HomeRepoImpl>().downloadFileAndSaveToGallery(
                      AppConstant.qrCodeBaseUrl, account.qr_img!);
                },
                icon: const Icon(Icons.arrow_circle_down),
                label: const Text("Download")),
            const Expanded(
              child: SizedBox(),
            ),
            IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.cancel_outlined,
                  size: 42,
                )),
            const SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    ));
  }
}

enum VirtualAccountCreationType { iciciBank, yesBank, none }
