import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/banner.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/home/component/bottom_sheet_option.dart';
import 'package:spayindia/page/main/home/component/home_service_section.dart';
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

  late ScrollController scrollController;

  var appbarBackgroundOpacity = 0.0.obs;
  var appbarElevation = 0.0.obs;
  var bannerList = <AppBanner>[].obs;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    appPreference.setIsTransactionApi(false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      scrollController.addListener(_scrollListener);
    });

    _fetchBanners();

    AppUpdateUtil.checkUpdate();
  }

  _fetchBanners() async {
    try {
      var response = await homeRepo.fetchBanners();
      if (response.banners != null) {

        var a = response.banners!;
        a.add(AppBanner(rawPicName: "https://spayindia.in/images/spay_features.png"));
        bannerList.value = a;
      }
    } catch (e) {}
    ;
  }

  _scrollListener() {
    var mOffset = scrollController.offset;

    if (mOffset < 101) {
      var colorOpacity = 0.01 * mOffset;

      if (colorOpacity > 1) {
        colorOpacity = 1;
      }
      if (colorOpacity < 0) {
        colorOpacity = 0;
      }
      appbarBackgroundOpacity.value = colorOpacity;

      var elevation = 20 * colorOpacity;


      appbarElevation.value = elevation;
    }

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
        Get.offAllNamed(AppRoute.loginPage);
      } else {
        Get.off(ExceptionPage(
          error: e,
        ));
      }
    }
  }



  onTopUpButtonClick (){
    Get.toNamed(AppRoute.fundRequestOptionPage);
  }

  onQRCodeButtonClick() {
    Get.toNamed(AppRoute.showQRCodePage);
  }

  void logout() async {
    await appPreference.logout();
    Get.offAllNamed(AppRoute.loginPage);
  }

  onItemClick(HomeServiceItem item) {
    switch (item.homeServiceType) {
      case HomeServiceType.aeps:
        Get.bottomSheet(AepsOptionDialog(
          onAepsClick: () {
            Get.toNamed(AppRoute.aepsPage, arguments: false);
          },
          onAadhaarPayClick:  () {
            Get.toNamed(AppRoute.aepsPage, arguments: true);
          },
        ));
        break;
      case HomeServiceType.matm:
        Get.toNamed(AppRoute.mamtPage);
        break;
      case HomeServiceType.moneyTransfer:
        {
          var dmtType = DmtType.instantPay;
          Get.toNamed(AppRoute.dmtSearchSenderPage,
              arguments: {"dmtType": dmtType});
        }
        break;
      case HomeServiceType.payoutTransfer:
        {
          var dmtType = DmtType.payout;
          Get.toNamed(AppRoute.dmtSearchSenderPage,
              arguments: {"dmtType": dmtType});
        }
        break;
      case HomeServiceType.recharge:
        {
          Get.bottomSheet(RechargeOptionDialog(
            onPrepaidClick: () {
              Get.toNamed(AppRoute.providerPage, arguments: ProviderType.prepaid);
            },
            onPostpaidClick: () {
              Get.toNamed(AppRoute.providerPage, arguments: ProviderType.postpaid);
            },
          ));
        }
        break;
      case HomeServiceType.dth:
        {
          Get.toNamed(AppRoute.providerPage, arguments: ProviderType.dth);
        }
        break;
      case HomeServiceType.billPayment:
        {
          Get.toNamed(AppRoute.providerPage,
              arguments: ProviderType.electricity);
        }
        break;
      case HomeServiceType.insurance:
        {
          Get.toNamed(AppRoute.providerPage,
              arguments: ProviderType.insurance);
        }
        break;
      case HomeServiceType.walletPay:
        {
          Get.toNamed(AppRoute.walletSearchPage);
        }
        break;

      case HomeServiceType.creditCard:
        {
          Get.toNamed(AppRoute.creditCardPage);
        }
        break;
      case HomeServiceType.lic:
        {
          Get.toNamed(AppRoute.licPaymentPage);
        }
        break;
      case HomeServiceType.paytmWallet:
        {
          Get.toNamed(AppRoute.paytmWalletLoadPage);
        }
        break;
      case HomeServiceType.ott:
        {
          Get.toNamed(AppRoute.ottOperatorPage);
        }
        break;
      default:
        break;
    }
  }

  onAddFundClick() {
    Get.toNamed(AppRoute.fundRequestPage);
  }

  onNotificationClick() {
    Get.toNamed(AppRoute.notificationPage);
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
  ott
}
