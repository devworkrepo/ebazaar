import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ebazaar/route/route_name.dart';
import 'package:ebazaar/widget/button.dart';
import 'package:ebazaar/widget/check_box.dart';
import 'package:ebazaar/widget/common.dart';
import 'package:ebazaar/widget/common/background_image.dart';
import 'package:ebazaar/widget/text_field.dart';
import 'package:ebazaar/page/auth/login/login_controller.dart';
import 'package:ebazaar/page/update_widget.dart';

class LoginPageBKP extends GetView<LoginController> {
  const LoginPageBKP({Key? key}) : super(key: key);

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

                _appLogo(),
                buildLoginTitle(),
                const SizedBox(height: 16),
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
                      Row(children: [

                        Expanded(child: SizedBox(
                          height: 40,
                          child: ElevatedButton(onPressed: (){}, child: Text("Retailer Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w400
                          ),),),
                        )),
                        const SizedBox(width: 8,),
                        Expanded(child: SizedBox(
                          height: 40,
                            child: ElevatedButton(onPressed: (){}, child: Text("Sub-retailer Login",
                            style: TextStyle(
                              fontWeight: FontWeight.w400
                            ),),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue[900]
                            ),))),
                      ],)



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
        "Login",
        style: Get.textTheme.headline4
            ?.copyWith(color: Get.theme.primaryColor,fontWeight: FontWeight.bold),
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
