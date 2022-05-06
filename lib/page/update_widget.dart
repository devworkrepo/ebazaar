import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/app_update.dart';
import 'package:spayindia/res/style.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/common/amount_background.dart';
import 'package:upgrader/upgrader.dart';
import 'package:version/version.dart';

import '../util/in_app_update.dart';

class AppUpdateWidget extends StatefulWidget {
  final Widget child;
  final Function(bool isUpdate)? onAvailable;

  const AppUpdateWidget({Key? key, required this.child, this.onAvailable})
      : super(key: key);

  @override
  _AppUpdateWidgetState createState() => _AppUpdateWidgetState();
}

class _AppUpdateWidgetState extends State<AppUpdateWidget> {
  AppPreference appPreference = Get.find();
  HomeRepo repo = Get.find<HomeRepoImpl>();

  @override
  void initState() {
    super.initState();
    updateCheck();
  }

  void updateCheck() async {
    await Upgrader().initialize();
    var value = Upgrader().isUpdateAvailable();
    if (!value) {
      AppUtil.logger("AppUpdate : update not available");

      var currentV = Upgrader().currentAppStoreVersion();
      var storeV = Upgrader().currentInstalledVersion();
      if (currentV == null || storeV == null) return;
      if (currentV.isEmpty || storeV.isEmpty) return;
      if (!currentV.contains(".") && !storeV.contains(".")) return;
      if (currentV == storeV) {
        AppUtil.logger("AppUpdate : update delay time setting up to 0");
        appPreference.setAppUpdateTimeWaiting(0);
      }
      return;
    }

    //callback for app update to child widget
    try {
      AppUtil.logger("AppUpdate : Network app update info on try block");
      AppUpdateInfo info = await repo.updateInfo();
      _setupUpdate(info);
    } catch (e) {
      AppUtil.logger("AppUpdate : Network app update info on catch block");
      _setupUpdate(AppUpdateInfo());
    }
  }

  _setupUpdate(AppUpdateInfo info) {
    bool isUpdate = info.isUpdate ?? true;
    bool isForce = info.isForce ?? true;

    if (widget.onAvailable != null && isUpdate) widget.onAvailable!(isUpdate);

    var ifForceUpdate = isForce ||
        !minVersionSupport(
            Upgrader().currentInstalledVersion(), info.minVersion);

    //check in app update
    AppUpdateUtil.checkUpdate(isUpdate, isForce);

    AppUtil.logger("AppUpdate : Update is available");
    if (appPreference.appUpdateTimeWaiting > 0) {
      AppUtil.logger("AppUpdateTesting : delay timestamp is greater than zero");
      var savedTime = DateTime.fromMillisecondsSinceEpoch(
              appPreference.appUpdateTimeWaiting)
          .add(Duration(hours: _getDelayHourInMilliSecond(info.delayHour)));

      if (DateTime.now().isAfter(savedTime)) {
        AppUtil.logger("AppUpdate : on after saved time");
        var playVersion = Upgrader().currentAppStoreVersion() ?? "N/A";
        var currentVersion = Upgrader().currentInstalledVersion() ?? "N/A";

        if (isUpdate) {
          Get.dialog(
            _ShowAppUpdateDialog(
              playVersion: playVersion,
              currentVersion: currentVersion,
              isForce: ifForceUpdate,
              heading: info.heading,
              description: info.description,
            ),
            barrierDismissible: (ifForceUpdate) ? false : true,
          );
        }
      }
    } else {
      AppUtil.logger(
          "AppUpdate : Initial timestamp is zero, setting up current timestamp");
      appPreference
          .setAppUpdateTimeWaiting(DateTime.now().millisecondsSinceEpoch);
    }
  }

  bool minVersionSupport(String? currentVersion, String? minVersion) {
    try {
      final mCurrentVersion = Version.parse(currentVersion);
      final mMinVersion = Version.parse(minVersion);
      return mCurrentVersion >= mMinVersion;
    } catch (e) {
      return true;
    }
  }

  int _getDelayHourInMilliSecond(String? delayHour) {
    var value = 2;
    try {
      value = int.parse((delayHour ?? "2"));
    } catch (e) {
      value = 2;
    }
    return value;
  }

  @override
  Widget build(BuildContext context) {
    var child = widget.child;
    return child;
  }
}

class _ShowAppUpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String playVersion;
  final bool isForce;
  final String? heading;
  final String? description;

  _ShowAppUpdateDialog(
      {required this.currentVersion,
      required this.playVersion,
      required this.isForce,
      this.heading,
      this.description,
      Key? key})
      : super(key: key);

  AppPreference appPreference = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isForce) {
          return false;
        } else {
          return true;
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                      child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.system_update,
                        size: 70,
                        color: Get.theme.primaryColorDark,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          (heading ?? "").isNotEmpty
                              ? heading!
                              : "App Update Available",
                          style:
                              Get.textTheme.headline6?.copyWith(fontSize: 24),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "New version of app is available in app store please update it.",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 12,),
                              Text(
                                "Current Version : $currentVersion",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Store Version     : $playVersion",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),

                              SizedBox(height: 12,),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(

                                  description ?? "",
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
                  const SizedBox(
                    height: 24,
                  ),
                  AppButton(
                      text: "Update",
                      onClick: () {
                        Upgrader().initialize().then((value) =>
                            Upgrader().onUserUpdated(context, false));
                        if (currentVersion == playVersion) {
                          Get.back();
                        }
                      }),
                  const SizedBox(
                    height: 16,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.bottomSheet(const _UpdateHelpWidget(),
                            isScrollControlled: true);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.help),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Need Help")
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _UpdateHelpWidget extends StatelessWidget {
  const _UpdateHelpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppStyle.bottomSheetDecoration(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 12, right: 12, bottom: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "App Update Help ? ",
              style: Get.textTheme.subtitle1,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Having problem to update the app. Don't worry we are here to guide you.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700]),
              ),
            ),
            AmountBackgroundWidget(
                child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Method 1. Goto play store -> Manage apps and device -> Mange -> Updates avaialble",
                      style: Get.textTheme.subtitle2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "If you don't see update available for spay India. Use method 2",
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Method 2. Goto Settings -> App Settings -> Find out Google Play Service. Just clear the the cache. Now try to update once more.",
                      style: Get.textTheme.subtitle2,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "If you don't see update available for spay India. Use method 3",
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Method 3. Uninstall the spay india app and reinstall from play store.",
                      style: Get.textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
