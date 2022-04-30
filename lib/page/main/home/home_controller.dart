import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/banner.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/home/component/bottom_sheet_option.dart';
import 'package:spayindia/page/main/home/component/home_service_section.dart';
import 'package:spayindia/page/main_page.dart';
import 'package:spayindia/page/recharge/provider/provider_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/service/local_auth.dart';
import 'package:spayindia/util/api/exception.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

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
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      scrollController.addListener(_scrollListener);
    });

    _fetchBanners();
  }

  _fetchBanners() async {
    try {
      var response = await homeRepo.fetchBanners();
      if (response.banners != null) {
        var mList = <AppBanner>[]; //response.banners!;
        /*response.banners!.forEach((element) {
          mList.add(element);
        });
        if(mList.isNotEmpty){
          mList.add(AppBanner(
              rawPicName: "https://spayindia.in/images/spay_features.png"));
        }*/

        mList.add(AppBanner(
            rawPicName: "https://spayindia.in/images/spay_features.png"));
        bannerList.value = mList;
      }
    } catch (e) {}
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

      await setupCrashID();

      if (response.code == 1) {
        isBottomNavShowObs.value = true;
        appbarBackgroundOpacity.value = 0;
        appbarElevation.value = 0;

        if (appPreference.isBiometricAuthentication && kReleaseMode) {
          if (!isLocalAuthDone) {
            LocalAuthService.authenticate().then((value) async {
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
    try {
      StatusDialog.progress(title: "Log out...");
      var response = await homeRepo.logout();
      Get.back();

      await appPreference.logout();
      Get.offAllNamed(AppRoute.loginPage);
    } catch (e) {
      await appPreference.logout();
      Get.offAllNamed(AppRoute.loginPage);
    }
  }

  onItemClick(HomeServiceItem item) {
    switch (item.homeServiceType) {
      case HomeServiceType.aeps:
        {
          Get.toNamed(AppRoute.aepsPage, arguments: false);
        }

        break;
      case HomeServiceType.aadhaarPay:{
        Get.toNamed(AppRoute.aepsPage, arguments: true);
      }

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
      case HomeServiceType.partBillPayment:
        {
          var provider = Provider.fromJson2(
            {
              "id": "93",
              "name": "Tata Power - Delhi / North Delhi Power Limited(NDPL)",
              "opcode": "TR79"
            },
          );

          Get.toNamed(AppRoute.billPaymentPage, arguments: {
            "is_part_bill": true,
            "provider": provider,
            "provider_name": getProviderInfo(ProviderType.electricity)?.name,
            "provider_image":
                getProviderInfo(ProviderType.electricity)?.imageName.toString(),
            "provider_type": ProviderType.electricity
          });
        }
        break;
      case HomeServiceType.insurance:
        {
          Get.toNamed(AppRoute.providerPage, arguments: ProviderType.insurance);
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

  onSummaryClick() {
    Get.toNamed(AppRoute.summaryPage);
  }

  Future<void> setupCrashID() async {
    var userId = appPreference.user.agentId.toString();
    var agentCode = appPreference.user.agentCode.toString();
    await FirebaseCrashlytics.instance.setCustomKey("user ID", userId);
    await FirebaseCrashlytics.instance.setCustomKey("user Code", agentCode);
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
