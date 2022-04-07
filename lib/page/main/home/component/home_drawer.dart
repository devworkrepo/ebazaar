import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_constant.dart';

import '../../logout_confirm_dialog.dart';

class HomeDrawerWidget extends GetView<HomeController> {
  const HomeDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Drawer(elevation: 16,
      child: Material(
        child: SafeArea(
          child: ListView(

            children: [

              _buildUserInfo(),

              ListTile(
                onTap: (){
                  Get.back();
                },
                title: Text(
                  "Home",
                  style: Get.textTheme.subtitle1,
                ),
                leading: const Icon(Icons.home),
              ),


              _NavTitle(
                title: "Reports",
                icon: Icons.receipt_outlined,
                children: [
                  _NavSubTitle(
                    title: "Transaction",
                    onClick: () {
                      Get.back();
                      Get.toNamed(RouteName.transactionReportPage);
                    },
                    count: 1,
                  ),
                  _NavSubTitle(
                    title: "Fund Report",
                    onClick: ()=>Get.toNamed(RouteName.fundReportPage),
                    count: 2,
                  ),
                  /*_NavSubTitle(
                    title: "Wallet Pay",
                    onClick: ()=>Get.toNamed(RouteName.aepsAllReportPage),
                    count: 2,
                  ),*/
                ],
              ),



              _NavTitle(
                title: "User Auth",
                icon: Icons.password,
                children: [
                  _NavSubTitle(
                    title: "Change Password",
                    onClick: () => Get.toNamed(RouteName.changePassword),
                    count: 1,
                  ),

                  _NavSubTitle(
                    title: "Change Pin",
                    onClick: () => Get.toNamed(RouteName.changePin),
                    underline: false,
                    count: 2,
                  )
                ],
              ),
              _NavTitle(
                title: "Aeps Service",
                icon: Icons.fingerprint,
                children: [
                  _NavSubTitle(
                    title: "On Board",
                    onClick: () => Get.toNamed(RouteName.aepsOnboardingPage),
                    count: 1,
                  ),

                  _NavSubTitle(
                    title: "E-Kyc",
                    onClick: () => Get.toNamed(RouteName.changePin),
                    underline: false,
                    count: 2,
                  )
                ],
              ),

              ListTile(
                onTap: (){
                 Get.toNamed(RouteName.appSetting);

                },
                title: Text(
                  "App Setting",
                  style: Get.textTheme.subtitle1,
                ),
                leading: const Icon(Icons.settings),
              ),

              ListTile(
                onTap: (){
                  Get.dialog(LogoutConfirmDialog(onConfirm: (){
                    controller.logout();
                  },));

                },
                title: Text(
                  "Logout",
                  style: Get.textTheme.subtitle1,
                ),
                leading: const Icon(Icons.power_settings_new),
              ),
            ],
          ),
        ),
      ),
    );
  }

   _buildUserInfo() {

    return Container(
      color: Get.theme.primaryColor,
      padding: EdgeInsets.all(16),
      child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColorDark,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        onError: (_, __) {}, image: NetworkImage(AppConstant.profileBaseUrl+controller.user.picName!), fit: BoxFit.contain),
                  ),
                ),
                  SizedBox(height: 8),
                Text("Welcome",style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),),
                  SizedBox(height: 4),
                Text("${controller.appPreference.user.fullName} - ${controller.appPreference.user.userType}",style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),),
                  SizedBox(height: 4),
                Text(controller.appPreference.mobileNumber,style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),),
              ],),
    );
  }
}

class _NavTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_NavSubTitle> children;

  const _NavTitle({Key? key, required this.title, required this.children, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(

        expandedAlignment: Alignment.centerLeft,
        maintainState: true,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        iconColor: Get.theme.primaryColorDark,
        leading: Icon(icon),
        childrenPadding: const EdgeInsets.only(left: 0, right: 8, bottom: 16),
        title: Text(
          title,
          style: Get.textTheme.subtitle1,
        ),
        children: children,
      ),
    );
  }
}

class _NavSubTitle extends StatelessWidget {
  final String title;
  final VoidCallback onClick;
  final bool underline;
  final int count;

  const _NavSubTitle(
      {Key? key,
      required this.title,
      required this.onClick,
      this.underline = true,
      required this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
        Get.back();
        onClick();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 32, right: 8, top: 8, bottom: 8),
            child: Row(
              children: [
                Container(
                  height: 20,
                  width: 20,
                  child: Center(
                      child: Text(
                    count.toString(),
                    style: const TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title,
                    style: Get.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.w400,color: Colors.black54,fontSize: 16))
              ],
            ),
          ),
          (underline)
              ? const Divider(
                  thickness: 0.5,
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
