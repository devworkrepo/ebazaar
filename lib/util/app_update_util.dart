import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:spayindia/component/common.dart';
import 'package:spayindia/model/app_update.dart';
import 'package:spayindia/service/firebase.dart';
import 'package:spayindia/util/app_util.dart';

class AppUpdateUtil {
  static checkUpdate() async {
    var inAppUpdateData = await _fetchUpdateFromFirebase();
    _checkForUpdate(inAppUpdateData);
  }

  static Future<void> _checkForUpdate(InAppUpdateData inAppUpdateData) async {
    InAppUpdate.checkForUpdate().then((info) {
      var isUpdateAvailable =
          info.updateAvailability == UpdateAvailability.updateAvailable;

      if (isUpdateAvailable) {
        if (inAppUpdateData.forceUpdate && inAppUpdateData.shouldUpdate) {
          _performImmediateUpdate();
        } else if (inAppUpdateData.shouldUpdate &&
            !inAppUpdateData.forceUpdate) {
          _performFlexibleUpdate();
        }
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

  static Future<InAppUpdateData> _fetchUpdateFromFirebase() async {
    var inAppUpdateData = await FirebaseService.fetchInAppUpdateData();
    return inAppUpdateData;
  }
}
