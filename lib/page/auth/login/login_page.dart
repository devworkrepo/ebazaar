import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/check_box.dart';
import 'package:spayindia/widget/common/background_image.dart';
import 'package:spayindia/widget/text_field.dart';
import 'package:spayindia/page/auth/login/login_controller.dart';
import 'package:spayindia/page/update_widget.dart';

import '../../../route/route_name.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());

    return const AppBackgroundImage(
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
                const SizedBox(
                  height: 16,
                ),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have spay account ? "),
                            TextButton(
                                onPressed: () {
                                  //  Get.toNamed(AppRoute.signupPage);
                                  Get.dialog(_SingUpDetailDialog());
                                },
                                child: const Text("Sing Up"))
                          ],
                        )
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
        style: Get.textTheme.headline4?.copyWith(
            color: Get.theme.primaryColor, fontWeight: FontWeight.w600),
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

class _SingUpDetailDialog extends StatelessWidget {
  const _SingUpDetailDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.asset("assets/image/logo.png",height: 50,),
              ),
             Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
               Text(
                 "Singup & Get Started!",
                 style: Get.textTheme.headline1?.copyWith(
                     fontWeight: FontWeight.bold, color: Colors.black),
               ),

               Text(
                 "Open your merchant account in seconds.",
                 style:
                 Get.textTheme.subtitle1?.copyWith(color: Colors.grey[700],fontWeight: FontWeight.w500),
               ),
             ],),
              const SizedBox(
                height: 16
              ),
              _buildItem(
                  title: "Fast Execution : ",
                  subTitle:
                      "99.9% of our transfers are ready with in 2-3 sec."),
              _buildItem(
                  title: "Guide & Support : ",
                  subTitle:
                      "24*7 dedicated support through Calls, Emails, and Live Chat."),
              _buildItem(
                  title: "Financial Secure :  ",
                  subTitle:
                      "We use industry leading technology to protect your money."),
              _buildItem(
                  title: "Banking Services :  ",
                  subTitle:
                      "AePS, Aadhaar Pay, Micro ATM, MPOS, Money Transfer."),
              _buildItem(
                  title: "Utility Services :  ",
                  subTitle: "Electricity & Water Bills, Flight Booking, Prepaid and Postpaid Services, Credit Card Payments and LIC Payments."),
              _buildItem(title: "CMS Services", subTitle: "All Loans and Insurance Payments."),


              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(children: [
                    Text("By clicking Sing Up, you agree to our",style: Get.textTheme.caption,),
                    Text("Terms and Conditions",
                    style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500,
                    color: Colors.blue),),
                  ],),
                ),
              ),

              SizedBox(height: 12,),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green
                  ),
                  onPressed: (){
                    Get.back();
                    Get.toNamed(AppRoute.signupPage);
                  },
                  child: const Text("SignUp Now"),),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem({required String title, required String subTitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 10,
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  )),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                    children: <TextSpan>[
                      TextSpan(
                          text: ' $subTitle',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.grey[600],
                          height: 1.4)),
                    ],
                  ),
                ),
              )
            ],
          ),
          Divider(indent: 0,color: Colors.grey.shade300,)
        ],
      ),
    );
  }
}
