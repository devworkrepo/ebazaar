import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/image.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/model/profile.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/page/profile/profile_controller.dart';
import 'package:spayindia/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/obx_widget.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("User Profile"),
      ),
      body: ObsResourceWidget<UserProfile>(
          obs: controller.responseObs,
          childBuilder: (data) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [_UserInfoSection(data),
                      _GeneralInfo(data),
                      _AddressInfo(data),
                      _ParentInfo(data),

                    ],
                  ),
                ),
              )),
    );
  }
}

// ignore: must_be_immutable
class _UserInfoSection extends StatelessWidget {

  final UserProfile profile;

  _UserInfoSection(this.profile,{Key? key}) : super(key: key);

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
                  _buidTitleValue("Available Bal","₹  "+ user.availableBalance.toString()),
                  _buidTitleValue("Opening Bal","₹  "+ user.openBalance.toString()),
                  _buidTitleValue("Credit Bal","₹  "+ user.creditBalance.toString()),
                ],
              ),
            ),
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


class _GeneralInfo extends StatelessWidget {

  final UserProfile profile;

  _GeneralInfo(this.profile,{Key? key}) : super(key: key);

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
              child: Column(
                children: [
                  _buidTitleValue("Outlet Name", profile.outlet_name),
                  _buidTitleValue("Mobile Number", profile.outlet_mobile),
                  _buidTitleValue("Email ID", profile.emailid),
                  _buidTitleValue("Pan Number", profile.pan_no),
                  _buidTitleValue("DOB", profile.dob),

                ],
              ),
            ),
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


class _AddressInfo extends StatelessWidget {

  final UserProfile profile;

  _AddressInfo(this.profile,{Key? key}) : super(key: key);

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
              child: Column(
                children: [
                  _buidTitleValue("State Name", profile.state_name),
                  _buidTitleValue("Address", profile.address),
                  _buidTitleValue("Pin Code", profile.pincode)

                ],
              ),
            ),
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

class _ParentInfo extends StatelessWidget {

  final UserProfile profile;

  _ParentInfo(this.profile,{Key? key}) : super(key: key);

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
              child: Column(
                children: [
                  _buidTitleValue("Distributor Name", profile.distributor_name),
                  _buidTitleValue("Distributor Mobile", profile.distributor_mobile),

                ],
              ),
            ),
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



