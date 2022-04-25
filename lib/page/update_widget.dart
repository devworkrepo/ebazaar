import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:upgrader/upgrader.dart';

class AppUpdateWidget extends StatefulWidget {
  final Widget child;

  const AppUpdateWidget({Key? key, required this.child}) : super(key: key);

  @override
  _AppUpdateWidgetState createState() => _AppUpdateWidgetState();
}

class _AppUpdateWidgetState extends State<AppUpdateWidget> {
  AppPreference appPreference = Get.find();

  @override
  void initState() {
    super.initState();
    updateCheck();
  }

  var isUpdateAvailable = false;

  void updateCheck() async {
    await Upgrader().initialize();
    var value = Upgrader().isUpdateAvailable();

    if (!value) {
      AppUtil.logger("AppUpdateTesting : Update is not available");
      appPreference.setAppUpdateDelayTime(0);
    } else {
      AppUtil.logger("AppUpdateTesting : Update is available");
      if (appPreference.appUpdateDelayTime > 0) {
        AppUtil.logger("AppUpdateTesting : timestamp is greater than zero");
       var savedTime = DateTime.fromMillisecondsSinceEpoch(appPreference.appUpdateDelayTime);

       if(DateTime.now().isAfter(savedTime)){
         AppUtil.logger("AppUpdateTesting : on after saved time");

         var playVersion = Upgrader().currentAppStoreVersion() ?? "N/A";
         var currentVersion = Upgrader().currentInstalledVersion() ?? "N/A";

         Get.dialog(
            _ShowAppUpdateDialog(playVersion: playVersion, currentVersion: currentVersion,),
           barrierDismissible: false,
         );
       }
      } else {
        AppUtil.logger("AppUpdateTesting : Initial timestamp is zero");
        var a = DateTime.now().add(const Duration(seconds: 36));
        appPreference.setAppUpdateDelayTime(a.millisecondsSinceEpoch);
      }
    }
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
   _ShowAppUpdateDialog({required this.currentVersion,required this.playVersion,Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              width: Get.width,
              height: Get.height,
              child: Column(
                children: [
                  Expanded(
                      child: Center(
                          child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.system_update,
                        size: 80,
                        color: Get.theme.primaryColorDark,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "App Update Available",
                          style: Get.textTheme.headline4
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black12),
                        child:  Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Column(children: [
                            Text(
                              "New version of app is available in app store please update it.",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16,),
                            Text(
                              "Current Version : $currentVersion",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Store Version     : $playVersion",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                            ),
                          ],)
                        ),
                      )
                    ],
                  ))),
                  AppButton(text: "Update", onClick: () {
                    Upgrader().initialize().then((value) => Upgrader().onUserUpdated(context,false));
                  })
                ],
              ),
            ),
            (kDebugMode || (appPreference.user.agentCode == "SPR01508" && appPreference.user.agentId == "1508"))? Positioned(
                right: 12,
                top: 12,
                child: IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.cancel,
                      size: 40,
                      color: Colors.grey,
                    ))) : const SizedBox()
          ],
        ),
      ),
    );
  }
}
