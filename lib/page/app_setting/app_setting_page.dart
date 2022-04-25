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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Obx(()=>_BuildSettingItem(
                title: "Biometric Authentication",
                hint: "Enable Biometric Authentication",
                description:
                (controller.biometricDescriptionText.value.isNotEmpty)
                    ? controller.biometricDescriptionText.value
                    : null,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildSettingItem extends GetView<AppSettingController> {
  final String title;
  final String hint;
  final String? description;

  const _BuildSettingItem(
      {required this.title, required this.hint, this.description, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey),
                )),
            Row(
              children: [
                Expanded(
                    child: Text(
                  hint,
                  style: Get.textTheme.subtitle1,
                )),
                Obx(() => Switch.adaptive(
                    value: controller.isBiometricLoginEnable.value,
                    onChanged: (newValue) {
                      controller.setBiometricLogin(newValue);
                    }))
              ],
            ),
            (description != null)
                ? Text(
                    description!,
                    style: Get.textTheme.subtitle2,
                  )
                : const SizedBox(),
            const Divider(
              indent: 0,
            )
          ],
        ),
      ),
    );
  }
}
