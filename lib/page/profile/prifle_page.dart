import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/image.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:spayindia/util/app_constant.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Profile"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [_UserInfoSection(), _UserServiceSection()],
          ),
        ),
      ),
    );
  }
}

class _UserServiceSection extends StatelessWidget {
  _UserServiceSection({Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();
  late UserDetail user;

  @override
  Widget build(BuildContext context) {
    user = appPreference.user;
    return Card(
      child: SizedBox(
        width: Get.width,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "App Services",
                  style: Get.textTheme.headline6?.copyWith(
                      color: Colors.blue[900], fontSize: 24),
                ),
              ),
              SizedBox(height: 8,),
              Divider(indent: 0,),
              SizedBox(height: 16,),
              _buildAppService("Money Transfer", user.isInstantPay),
              _buildAppService("Payout Transfer", true),
              _buildAppService("Aeps Withdrawal", user.isAeps),
              _buildAppService("Micro ATM ", user.isAeps),
              _buildAppService("Bill Payment", user.isBill),
              _buildAppService("Insurance", user.isInsurance),
              _buildAppService("DTH Recharge", user.isDth),
              _buildAppService("Mobile Recharge", user.isRecharge),
              _buildAppService("Wallet Pay", user.isWalletPay),
              _buildAppService("Paytm Wallet", user.isPaytmWallet),
              _buildAppService("OTT Subscription", user.isOtt),
              _buildAppService("LIC Premium", user.isLic),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppService(String title, bool? value) {

    if(!(value ?? false)){
      return SizedBox();
    }

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: Get.textTheme.bodyText1
                ?.copyWith(fontWeight: FontWeight.w600,
                fontSize: 16,
                color: ((value ?? false) ? Colors.black : Colors.red)),
          ),
        ),
        Switch.adaptive(value: value ?? false, onChanged: (value) {})
      ],
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  _UserInfoSection({Key? key}) : super(key: key);

  AppPreference appPreference = Get.find();
  late UserDetail user;

  @override
  Widget build(BuildContext context) {
    user = appPreference.user;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              width: Get.width,
              decoration: BoxDecoration(color: Get.theme.primaryColor),
              child: Column(
                children: [
                  AppCircleNetworkImage(
                    AppConstant.profileBaseUrl + (user.picName ?? ""),
                    size: 80,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    (user.fullName ?? "") + "  (" + (user.userType ?? "") + ")",
                    style:
                    Get.textTheme.headline6?.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Agent Id - " + (user.agentId ?? ""),
                    style: Get.textTheme.bodyText1
                        ?.copyWith(color: Colors.white70),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Agent Code - " + (user.agentCode ?? ""),
                    style: Get.textTheme.bodyText1
                        ?.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  _buidTitleValue("Outlet Name", "₹  "+user.outletName.toString()),
                  _buidTitleValue("Available Bal","₹  "+ user.availableBalance.toString()),
                  _buidTitleValue("Opening Bal","₹  "+ user.openBalance.toString()),
                  _buidTitleValue("Credit Bal","₹  "+ user.creditBalance.toString()),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buidTitleValue(String title, String? value) {
    return BuildTitleValueWidget(
      title: title,
      value: value ?? "",
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
  }
}
