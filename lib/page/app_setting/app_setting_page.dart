import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/app_setting/app_setting_controller.dart';

class AppSettingPage extends GetView<AppSettingController> {
  const AppSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AppSettingController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("App Setting"),
      ),
      body: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _BuildSettingItem(

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildSettingItem extends GetView<AppSettingController> {
  const _BuildSettingItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: const Text("Biometric Authentication",style: TextStyle(color:Colors.grey),)),
          Row(
            children: [
              Expanded(
                  child: Text(
                "Enable Biometric Authenticaiton",
                style: Get.textTheme.subtitle1,
              )),
              Obx(() => Switch.adaptive(
                  value: controller.isBiometricLoginEnable.value,
                  onChanged: (newValue) {
                    controller.isBiometricLoginEnable.value = newValue;
                  }))
            ],
          ),
          Divider(
            indent: 0,
          )
        ],
      ),
    );
  }
}
