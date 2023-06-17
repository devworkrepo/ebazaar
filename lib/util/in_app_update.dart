import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:in_app_update/in_app_update.dart' as inAppUpdate;
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/app_update.dart';

import '../widget/common.dart';
import 'app_util.dart';

class AppUpdateUtil {

  AppUpdateUtil._();

  static Future<void> checkUpdate() async {


    InAppUpdate.checkForUpdate().then((info)  async{
      var isUpdateAvailable =
          info.updateAvailability == UpdateAvailability.updateAvailable;

      AppUtil.logger("InAppUpdate : package name : ${info.packageName}");

      if (isUpdateAvailable) {
        _fetchUpdateDetail();
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


  static _fetchUpdateDetail() async{
    try{
      NetworkAppUpdateInfo info = await Get.find<HomeRepoImpl>().updateInfo();
      _performImmediateUpdate(info.isUpdate ?? true,info.isForce ?? true);
    }catch(e){
      _performImmediateUpdate(true,true);
    }
  }

  static _performImmediateUpdate(bool isUpdate, bool isForceUpdate) {
    if(!isUpdate) return;
    InAppUpdate.performImmediateUpdate().catchError((e) {
      AppUtil.logger(
          "InAppUpdateError _performImmediateUpdate: " + e.toString());
      if(isForceUpdate){
        checkUpdate();
      }
    }).then((value) {
     var success =  inAppUpdate.AppUpdateResult.success;
      if( value != success){
        if(isForceUpdate){ checkUpdate();}
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
