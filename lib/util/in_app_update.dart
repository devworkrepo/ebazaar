import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';

import '../widget/common.dart';
import 'app_util.dart';

class AppUpdateUtil {

  AppUpdateUtil._();

  static Future<void> checkUpdate(bool isUpdate, bool isForceUpdate) async {

    if(!isUpdate) return;

    InAppUpdate.checkForUpdate().then((info) {
      var isUpdateAvailable =
          info.updateAvailability == UpdateAvailability.updateAvailable;

      AppUtil.logger("InAppUpdate : package name : ${info.packageName}");

      if (isUpdateAvailable) {
        _performImmediateUpdate(isUpdate,isForceUpdate);
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

  static _performImmediateUpdate(bool isUpdate, bool isForceUpdate) {
    InAppUpdate.performImmediateUpdate().catchError((e) {
      AppUtil.logger(
          "InAppUpdateError _performImmediateUpdate: " + e.toString());
      if(isForceUpdate){
        checkUpdate(isUpdate,isForceUpdate);
      }
    });
  }

  static _performFlexibleUpdate() {
    InAppUpdate.startFlexibleUpdate().then((value) =>
        InAppUpdate.completeFlexibleUpdate().then((value) =>
            showSuccessSnackbar(
                title: "Update Completed", message: "App is update to date")));
  }


}
