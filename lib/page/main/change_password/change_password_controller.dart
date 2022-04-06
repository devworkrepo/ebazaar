import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/route/route_name.dart';

import '../../exception_page.dart';

class ChangePasswordController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  changePassword() async {

    try {
      StatusDialog.progress(title: "Progressing");

      var response = await repo.requestOtp(
          {
            "old_password": oldPasswordController.text.toString(),
            "new_password": newPasswordController.text.toString(),
            "confirm_new_password": confirmPasswordController.text.toString(),
          });
      Get.back();

      if (response.code == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => Get.offAllNamed(RouteName.loginPage));
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  @override
  void dispose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
