import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/res/color.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_constant.dart';

import '../../../../widget/image.dart';
import '../../logout_confirm_dialog.dart';

class HomeDrawerWidget extends GetView<HomeController> {
  const HomeDrawerWidget({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final Color color = Get.theme.primaryColorDark;
    return Drawer(elevation: 16,
      child: Material(
        child: SafeArea(
          child: Card(
            color: Colors.white.withOpacity(0.9),
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.all(4),
            child: ListView(

              children: [

                _buildUserInfo(),

                Card(
                  child: ListTile(
                    onTap: (){
                      Get.back();
                      controller.fetchUserDetails();
                    },
                    title: Text(
                      "Home",
                      style: Get.textTheme.subtitle1?.copyWith(color: color,fontWeight: FontWeight.bold),
                    ),
                    leading:  Icon(Icons.home,color: color,),
                  ),
                ),


                Card(
                  child: _NavTitle(
                    title: "Reports",
                    icon: Icons.receipt_outlined,
                    children: [
                      _NavSubTitle(
                        title: "Transaction",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.transactionReportPage);
                        },
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "Statement",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.statementReportPage);
                        },
                        count: 2,
                      ),
                      _NavSubTitle(
                        title: "Refund Pending",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.refundReportPage);
                        },
                        count: 3,
                      ),

                      _NavSubTitle(
                        title: "Wallet Pay",
                        onClick: ()=>Get.toNamed(AppRoute.walletReportPage),
                        count: 4,
                      ),
                    ],
                  ),
                ),

                Card(
                  child: _NavTitle(
                    title: "Fund Request",
                    icon: Icons.money,
                    children: [
                      _NavSubTitle(
                        title: "New Request",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.fundRequestPage);
                        },
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "Pending Request",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.fundReportPage,arguments: {
                            "is_pending" : true
                          });
                        },
                        count: 2,
                      ),
                      _NavSubTitle(
                        title: "All Request",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.fundReportPage,
                              arguments: {
                                "is_pending" : false
                              });
                        },
                        count: 3,
                      ),
                    ],
                  ),
                ),


                Card(
                  child: _NavTitle(
                    title: "Aeps Service",
                    icon: Icons.fingerprint,

                    children: [
                     /* _NavSubTitle(
                        title: "OnBoarding",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsOnboardingPage);
                        },
                        count: 1,
                      ),

                      _NavSubTitle(
                        title: "E-Kyc",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsEkycPage);
                        },
                        underline: false,
                        count: 2,
                      ),*/
                      _NavSubTitle(
                        title: "Balance Settlement",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.aepsSettlementPage);
                        },
                        underline: false,
                        count: 1,
                      )
                    ],
                  ),
                ),

                Card(
                  child: _NavTitle(
                    title: "Settings",
                    icon: Icons.settings_rounded,

                    children: [
                      _NavSubTitle(
                        title: "Login Sessions",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.manageLoginSession);
                        },
                        count: 1,
                      ),
                      _NavSubTitle(
                        title: "Change Password",
                        onClick: (){
                          Get.back();
                          Get.toNamed(AppRoute.changePassword);
                        },
                        count: 2,
                      ),

                      _NavSubTitle(
                        title: "Change Pin",
                        onClick: () {
                          Get.back();
                          Get.toNamed(AppRoute.changePin);
                        },
                        underline: false,
                        count: 3,
                      )
                    ],
                  ),
                ),


                Card(
                  child: ListTile(
                    onTap: (){
                      Get.back();
                      Get.dialog(LogoutConfirmDialog(onConfirm: (){
                        controller.logout();
                      },));

                    },
                    title: Text(
                      "Logout",
                      style: Get.textTheme.subtitle1?.copyWith(color: color,fontWeight: FontWeight.bold),
                    ),
                    leading:  Icon(Icons.power_settings_new,color: color,),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   _buildUserInfo() {
    return Card(
      color: Get.theme.primaryColor,

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppCircleNetworkImage(AppConstant.profileBaseUrl+controller.user.picName.toString(),size: 70,),
                    const SizedBox(height: 8),
                  Text("Welcome",style: Get.textTheme.subtitle1?.copyWith(color: Colors.white),),
                    const SizedBox(height: 4),
                  Text("${controller.appPreference.user.fullName} - ${controller.appPreference.user.userType}",style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),),
                    const SizedBox(height: 4),
                  Text(controller.appPreference.mobileNumber,style: Get.textTheme.subtitle2?.copyWith(color: Colors.white70),),
                ],),
      ),
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
        leading: Icon(icon,color: Get.theme.primaryColorDark,),
        childrenPadding: const EdgeInsets.only(left: 0, right: 8, bottom: 16),
        title: Text(
          title,
          style: Get.textTheme.subtitle1?.copyWith(color: Get.theme.primaryColorDark,fontWeight: FontWeight.bold),
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
                const EdgeInsets.only(left: 32, right: 8, top: 12, bottom: 12),
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
                      color: Get.theme.primaryColorLight,
                      borderRadius: BorderRadius.circular(30)),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(title,
                    style: Get.textTheme.subtitle1
                        ?.copyWith(fontWeight: FontWeight.w500,color: Colors.black54,fontSize: 16))
              ],
            ),
          ),

        ],
      ),
    );
  }
}
