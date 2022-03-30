import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/common/counter_widget.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/auth/fogot_password/forgot_password_controller.dart';
import 'package:spayindia/res/color.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: const SingleChildScrollView(
        child: _ForgotPasswordForm(),
      ),
    );
  }
}

class _ForgotPasswordForm extends GetView<ForgotPasswordController> {
  const _ForgotPasswordForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                  key: controller.forgotPasswordFormKey,
                  child: Column(
                    children: [
                      Obx(() => (controller.forgotPasswordRequestType.value ==
                              ForgotPasswordRequestType.requestPassword)
                          ? _mobileForm()
                          : _mobileAndPasswordForm()),
                      Obx(() => (controller.forgotPasswordRequestType.value ==
                              ForgotPasswordRequestType.verifyOtp)
                          ? Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppColor.backgroundColor,
                              ),
                              child: Text(
                                controller.message.value,
                                textAlign: TextAlign.center,
                                style: const TextStyle(letterSpacing: 1),
                              ),
                            )
                          : const SizedBox()),
                      const SizedBox(
                        height: 32,
                      ),
                      Obx(() => AppButton(
                          text: (controller.forgotPasswordRequestType.value ==
                                  ForgotPasswordRequestType.requestPassword)
                              ? "Proceed"
                              : "Submit & Verify",
                          onClick: () => controller.onSubmit())),
                      const SizedBox(
                        height: 24,
                      ),
                      Obx(() {
                        return (controller.forgotPasswordRequestType.value ==
                                ForgotPasswordRequestType.verifyOtp)
                            ? (controller.resendButtonVisibilityObs.value)
                                ? SizedBox(
                                    width: Get.width,
                                    height: 48,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        controller.resendOtp();
                                      },
                                      child: const Text("Resend Otp"),
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Get.theme.primaryColor)),
                                    ))
                                : CounterWidget(
                                    onTimerComplete: () {
                                      controller.resendButtonVisibilityObs
                                          .value = true;
                                    },
                                  )
                            : const SizedBox();
                      })
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _mobileForm() {
    return MobileTextField(

      controller: controller.mobileController,
    );
  }

  _mobileAndPasswordForm() {
    return Column(
      children: [
        MobileTextField(
          enable: false,
          controller: controller.mobileController,
        ),
        PasswordTextField(

          label: "New Password",
          hint: "Enter New Password",
          controller: controller.newPasswordController,
        ),
        PasswordTextField(

          label: "Confirm Password",
          hint: "Confirm Password",
          controller: controller.confirmPasswordController,
        ),
        OtpTextField(

          maxLength: 6,
          controller: controller.otpController,
        ),
      ],
    );
  }
}
