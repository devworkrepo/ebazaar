import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/widget/button.dart';
import 'package:ebazaar/widget/common/background_image.dart';
import 'package:ebazaar/widget/common/counter_widget.dart';
import 'package:ebazaar/widget/text_field.dart';
import 'package:ebazaar/res/color.dart';

import 'login_otp_controller.dart';

class LoginOtpPage extends GetView<LoginOtpController> {
  const LoginOtpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginOtpController());
    return AppBackgroundImage(
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: _LoginForm(),
      ),
    );
  }
}

class _LoginForm extends GetView<LoginOtpController> {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _appLogo(),
              buildLoginTitle(),
              Container(
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColor.backgroundColor,
                ),
                child: Text(
                  controller.loginData.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(letterSpacing: 1),
                ),
              ),
              const SizedBox(height: 12),
              Form(
                  key: controller.deviceVerificationFormKey,
                  child: Column(
                    children: [
                      OtpTextField(

                        controller: controller.otpController,
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      AppButton(
                          width: 200,
                          isRounded: true,
                          text: "Verify Otp",
                          onClick: () => controller.verifyOtp()),

                      (!(controller.loginData.hideresend ?? false)) ?  Column(children: [
                        const SizedBox(height: 24),
                        Obx((){
                          return (controller.resendButtonVisibilityObs.value)
                              ? SizedBox(
                              width: 200,
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  controller.resendOtp();
                                },
                                child: const Text("Resend Otp"),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(100.0),
                                            side: BorderSide(color: Colors.red)
                                        )
                                    )
                                ),
                              ))
                              : CounterWidget(
                            onTimerComplete: () {
                              controller.resendButtonVisibilityObs.value = true;
                            },
                          );
                        })
                      ],) : SizedBox()
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Padding buildLoginTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Login Otp",
        style: Get.textTheme.headline4
            ?.copyWith(color: Get.theme.primaryColorDark),
      ),
    );
  }

  _appLogo() => Image.asset(
        "assets/image/logo.png",
        height: 70,
        width: 200,
      );
}
