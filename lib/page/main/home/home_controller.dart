import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/home/component/home_service_section.dart';
import 'package:spayindia/page/main/home/component/bottom_sheet_option.dart';
import 'package:spayindia/page/main_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/service/loca_auth.dart';
import 'package:spayindia/util/api/exception.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_update_util.dart';

var isLocalAuthDone = false;
class HomeController extends GetxController {
  HomeRepo homeRepo = Get.find<HomeRepoImpl>();
  AppPreference appPreference = Get.find();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var userDetailObs = Resource.onInit(data: UserDetail()).obs;
  late UserDetail user;



  @override
  void onInit() {
    super.onInit();
    AppUpdateUtil.checkUpdate();
  }

  fetchUserDetails() async {

   WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      isBottomNavShowObs.value = false;
    });

    userDetailObs.value = const Resource.onInit();
    try {
      UserDetail response = await homeRepo.fetchAgentInfo();
      user = response;
      await appPreference.setUser(user);
      if(response.code == 1){
        isBottomNavShowObs.value = true;

        if(appPreference.isBiometricAuthentication){
          if(!isLocalAuthDone){
            LocalAuthService.authenticate().then((value) {
              isLocalAuthDone = true;
            });
          }
        }
      }
      userDetailObs.value = Resource.onSuccess(response);
    } catch (e) {
      isBottomNavShowObs.value = false;
      userDetailObs.value = Resource.onFailure(e);

      if (getDioException(e) is SessionExpireException) {
        Get.offAllNamed(RouteName.loginPage);
      } else {
        Get.off(ExceptionPage(
          error: e,
        ));
      }
    }
  }



  onTopUpButtonClick (){
    Get.toNamed(RouteName.fundRequestOptionPage);
  }

  onQRCodeButtonClick() {
    Get.toNamed(RouteName.showQRCodePage);
  }

  void logout() async {
    await appPreference.logout();
    Get.offAllNamed(RouteName.loginPage);
  }

  onItemClick(HomeServiceItem item) {
    switch (item.homeServiceType) {
      case HomeServiceType.aeps:
        Get.bottomSheet(AepsOptionDialog(
          onAepsClick: () {
            Get.toNamed(RouteName.aepsPage, arguments: false);
          },
          onAadhaarPayClick:  () {
            Get.toNamed(RouteName.aepsPage, arguments: true);
          },
        ));
        break;
      case HomeServiceType.matm:
        Get.toNamed(RouteName.mamtPage);
        break;
      case HomeServiceType.moneyTransfer:
        {
          var dmtType = DmtType.instantPay;
          Get.toNamed(RouteName.dmtSearchSenderPage,
              arguments: {"dmtType": dmtType});
        }
        break;
      case HomeServiceType.payoutTransfer:
        {
          var dmtType = DmtType.payout;
          Get.toNamed(RouteName.dmtSearchSenderPage,
              arguments: {"dmtType": dmtType});
        }
        break;
      case HomeServiceType.recharge:
        {
          Get.bottomSheet(RechargeOptionDialog(
            onPrepaidClick: () {
              Get.toNamed(RouteName.providerPage, arguments: ProviderType.prepaid);
            },
            onPostpaidClick: () {
              Get.toNamed(RouteName.providerPage, arguments: ProviderType.postpaid);
            },
          ));
        }
        break;
      case HomeServiceType.dth:
        {
          Get.toNamed(RouteName.providerPage, arguments: ProviderType.dth);
        }
        break;
      case HomeServiceType.billPayment:
        {
          Get.toNamed(RouteName.providerPage,
              arguments: ProviderType.electricity);
        }
        break;
      case HomeServiceType.insurance:
        {
          Get.toNamed(RouteName.providerPage,
              arguments: ProviderType.insurance);
        }
        break;
      case HomeServiceType.walletPay:
        {
          Get.toNamed(RouteName.walletSearchPage);
        }
        break;
      default:
        break;
    }
  }

  onAddFundClick() {
    Get.toNamed(RouteName.fundRequestPage);
  }
}

class HomeService {
  String title;
  String iconPath;
  VoidCallback? onClick;

  HomeService({
    required this.title,
    required this.iconPath,
    this.onClick,
  });


}

enum ProviderType {
  prepaid,
  dth,
  electricity,
  water,
  gas,
  postpaid,
  landline,
  broadband,
  insurance,
}
