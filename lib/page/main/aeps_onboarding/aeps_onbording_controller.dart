import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/aeps/aeps_state.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/util/mixin/location_helper_mixin.dart';
import 'package:spayindia/util/mixin/transaction_helper_mixin.dart';

import '../../../data/repo/aeps_aitel_repo.dart';
import '../../../data/repo_impl/aeps_aitel_impl.dart';
import '../../../service/location.dart';
import '../../../util/app_util.dart';
import '../../exception_page.dart';

class AepsOnboardingController extends GetxController
    with LocationHelperMixin, TransactionHelperMixin {
  AepsRepo repo = Get.find<AepsRepoImpl>();
  AepsAirtelRepo aepsAitelRepo = Get.find<AepsAirtelRepoImpl>();

  bool isApesTramo = Get.arguments ?? true;

  var aadhaarController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var stateListResponseObs = Resource.onInit(data: AepsStateListResponse()).obs;
  late List<AepsState> aepsStateList;

  AepsState? selectedState;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      validateLocation(progress: false);
      if (isApesTramo) _fetchAepsState();
    });
  }

  _fetchAepsState() async {
    try {
      obsResponseHandler<AepsStateListResponse>(
          obs: stateListResponseObs,
          apiCall: repo.getAepsState(),
          onResponse: (data) {
            aepsStateList = data.stateList!;
          });
    } catch (e) {
      Get.dialog(ExceptionPage(error: e));
    }
  }

  onProceed() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      position = await LocationService.determinePosition();
      AppUtil.logger("Position : " + position.toString());
    } catch (e) {
      return;
    }
    try {
      StatusDialog.progress(title: "Progressing");
      var response = (isApesTramo)
          ? await repo.onBoardAeps({
              "aadhar_no": aadhaarWithoutSymbol(aadhaarController),
              "stateid": selectedState!.id.toString(),
              "statename": selectedState!.name.toString(),
              "latitude": position!.latitude.toString(),
              "longitude": position!.longitude.toString(),
            })
          : await aepsAitelRepo.aepsOnBoarding({
              "aadhar_no": aadhaarWithoutSymbol(aadhaarController),
              "latitude": position!.latitude.toString(),
              "longitude": position!.longitude.toString(),
            });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message);
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    aadhaarController.dispose();
    super.dispose();
  }
}
