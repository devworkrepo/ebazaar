import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/widget/button.dart';

import '../../../biometric_setting_page.dart';

class HomeBiometricDialog extends GetView<HomeController> {
  const HomeBiometricDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white, width: 1)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/image/biometric.png",
                height: 120,
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Enable Biometric ",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "To secure login, please enable biometric authentication from app setting.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              AppButton(
                  text: "Enable",
                  width: 200,
                  onClick: () {
                    Get.back();
                    Get.to(() => const BiometricSettingPage());
                  }),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                    onPressed: () {
                      Get.back();
                      controller.appPreference.setIsSkipBiometricPopUp(true);
                    },
                    child: Text(
                      "Skip and don't show again",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
