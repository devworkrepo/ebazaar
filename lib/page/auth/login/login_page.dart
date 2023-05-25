
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/check_box.dart';
import 'package:spayindia/widget/common/background_image.dart';
import 'package:spayindia/widget/text_field.dart';
import 'package:spayindia/page/auth/login/login_controller.dart';
import 'package:spayindia/page/update_widget.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return  const AppBackgroundImage(
      child: AppUpdateWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: _LoginForm(),
        ),
      ),
    );
  }
}

class _LoginForm extends GetView<LoginController> {
  const _LoginForm({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 16,),
                _appLogo(),
                buildLoginTitle(),
                const SizedBox(height: 24),
                Form(
                    key: controller.loginFormKey,
                    child: Column(
                      children: [
                        MobileTextField(
                          controller: controller.mobileController,
                        ),
                        PasswordTextField(
                          controller: controller.passwordController,
                        ),
                        AppCheckBox(
                            title: "Remember Login",
                            value: controller.isLoginCheck.value,
                            onChange: (value) {
                              controller.isLoginCheck.value = value;
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        AppButton(
                            width: 200,
                            isRounded: true,
                            text: "Login",
                            onClick: () => controller.login()),


                      /*  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have spay account ? "),
                            TextButton(onPressed: (){
                              Get.toNamed(AppRoute.signupPage);
                            }, child: const Text("Sing Up"))
                          ],
                        )*/

                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoginTitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        "Retailer Login",
        style: Get.textTheme.headline4
            ?.copyWith(color: Get.theme.primaryColor,fontWeight: FontWeight.w600),
      ),
    );
  }

  _appLogo() => Container(
    color: Colors.transparent,
    child: Image.asset(
          "assets/image/logo.png",
          width: 80,
        ),
  );
}
