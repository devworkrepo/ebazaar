import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:spayindia/data/app_pref.dart';

import '../widget/common.dart';
import 'app_util.dart';

class AppUpdateUtil {
  static checkUpdate() async {
    AppPreference appPreference = Get.find();
    var savedTime =
        DateTime.fromMillisecondsSinceEpoch(appPreference.appUpdateDelayTime);
    if (!DateTime.now().isAfter(savedTime) ||
        savedTime.isBefore(DateTime(2021))) {
      _checkForUpdate();
    }
  }

  static Future<void> _checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      var isUpdateAvailable =
          info.updateAvailability == UpdateAvailability.updateAvailable;

      AppUtil.logger("InAppUpdate : package name : ${info.packageName}");

      if (isUpdateAvailable) {
        if (true) {
          _performImmediateUpdate();
        } else {
          _performFlexibleUpdate();
        }
      } else {
        AppUtil.logger("InAppUpdate : app update not available");
      }
    }).catchError((e) {
      AppUtil.logger("InAppUpdateError : _checkForUpdate" + e.toString());

      if (e is PlatformException) {
      } else {
        showFailureSnackbar(title: "Update Failed", message: e.toString());
      }
    });
  }

  static _performImmediateUpdate() {
    InAppUpdate.performImmediateUpdate().catchError((e) {
      AppUtil.logger(
          "InAppUpdateError _performImmediateUpdate: " + e.toString());
      showFailureSnackbar(title: "Update Failed", message: e.toString());
    });
  }

  static _performFlexibleUpdate() {
    InAppUpdate.startFlexibleUpdate().then((value) =>
        InAppUpdate.completeFlexibleUpdate().then((value) =>
            showSuccessSnackbar(
                title: "Update Completed", message: "App is update to date")));
  }
}
