import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/alert.dart';
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
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

import 'component/home_biometric_dialog.dart';
import 'component/home_service_section_2.dart';

var isLocalAuthDone = false;
var firstNotificationPlayed = false;

class HomeController extends GetxController {
  var isUpdateObs = false.obs;

  HomeRepo homeRepo = Get.find<HomeRepoImpl>();
  AppPreference appPreference = Get.find();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  var userDetailObs = Resource.onInit(data: UserDetail()).obs;
  late UserDetail user;

  late ScrollController scrollController;

  var appbarBackgroundOpacity = 0.0.obs;
  var appbarElevation = 0.0.obs;
  var bannerList = <AppBanner>[].obs;

  var alertMessageObs = AlertMessageResponse().obs;

  bool skipBiometric = false;

  @override
  void onInit() {
    super.onInit();

    scrollController = ScrollController();
    appPreference.setIsTransactionApi(false);
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      scrollController.addListener(_scrollListener);
      _fetchBanners();
    });
  }

  _fetchAlerts() async {
    try {
      var response = await homeRepo.alertMessage();
      alertMessageObs.value = response;
      playNotificationSound();
    } catch (e) {}
  }

  _fetchBanners() async {
    try {
      var response = await homeRepo.fetchBanners();
      if (response.banners != null) {
        var mList = <AppBanner>[]; //response.banners!;
        response.banners!.forEach((element) {
          mList.add(element);
        });
        if (mList.isEmpty) {
          mList.add(AppBanner(
              rawPicName: "https://spayindia.in/images/spay_features.png"));
        }
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

  authenticateSecurity() async {
    if (appPreference.isBiometricAuthentication) {
      if (!isLocalAuthDone) {
        final result = await LocalAuthService.authenticate();
        isLocalAuthDone = result;
        _fetchAlerts();
        firstNotificationPlayed = result;
      }
    } else {
      firstNotificationPlayed = true;
      if (!skipBiometric) {
        if (!(Get.isDialogOpen ?? true)) {
          if (Get.currentRoute == AppRoute.mainPage) {
            Get.dialog(const HomeBiometricDialog(), barrierDismissible: false);
          }
        }
      }
    }
  }

  fetchUserDetails() async {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      isBottomNavShowObs.value = false;
      _fetchUserDetails();
      if (firstNotificationPlayed) _fetchAlerts();
    });
  }

  _fetchUserDetails() async {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      isBottomNavShowObs.value = false;
    });
    userDetailObs.value = const Resource.onInit();
    try {
      AppUtil.throwUatExceptionOnDeployment(appPreference.mobileNumber);

      UserDetail response = await homeRepo.fetchAgentInfo();
      user = response;
      await appPreference.setUser(user);

      authenticateSecurity();

      await setupCrashID();

      if (response.code == 1) {
        isBottomNavShowObs.value = true;
        appbarBackgroundOpacity.value = 0;
        appbarElevation.value = 0;

        //firebase token
        _firebaseServices();
      }
      userDetailObs.value = Resource.onSuccess(response);
    } catch (e) {
      isBottomNavShowObs.value = false;
      userDetailObs.value = Resource.onFailure(e);

      if (getDioException(e) is SessionExpireException) {
        Get.offAllNamed(AppRoute.loginPage);
      } else {
        Get.dialog(ExceptionPage(error: e));
      }
    }
  }

  _firebaseServices() async {
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      AppUtil.logger("FirebaseService onRefreshToken: $event");
    });

    FirebaseMessaging.instance.getToken().then((token) {
      AppUtil.logger("FirebaseService : token : $token");
    });

    FirebaseMessaging.onMessage.listen((event) {
      /*AppUtil.logger("Firebase Service == message from foreground");
      LocalNotificationService.showNotificationOnForeground(message: event);*/
    });
  }

  onTopUpButtonClick() {
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

  onItemClick2(HomeServiceItem2 item) {
    Get.toNamed(AppRoute.createInvestmentPage);
  }

  onItemClick(HomeServiceItem item) {
    switch (item.homeServiceType) {
      case HomeServiceType.aeps:
        {
          Get.bottomSheet(AepsDialogWidget(
            onAirtel: () {
              Get.toNamed(AppRoute.aepsAirtelPage);
            },
            onTramo: () {
              Get.toNamed(AppRoute.aepsTramoPage, arguments: false);
            },
          ));
        }
        break;
      case HomeServiceType.aadhaarPay:
        {
          Get.toNamed(AppRoute.aepsTramoPage, arguments: true);
        }

        break;
      case HomeServiceType.matm:
        {
          var user = appPreference.user;
          var isMatm = user.isMatm ?? false;
          var isMatmCredo = user.is_matm_credo ?? false;
          var isMposCredo = user.is_mpos_credo ?? false;

          if ((isMatm || isMatmCredo) && isMposCredo) {
            Get.bottomSheet(MatmOptionDialog(
              matmClick: () {
                if (isMatm) {
                  Get.toNamed(AppRoute.matmTramopage);
                } else if (isMatmCredo) {
                  Get.toNamed(AppRoute.matmCredoPage, arguments: true);
                }
              },
              mposClick: () {
                Get.toNamed(AppRoute.matmCredoPage, arguments: false);
              },
            ));
          } else if (isMposCredo) {
            Get.toNamed(AppRoute.matmCredoPage, arguments: false);
          } else if (isMatmCredo) {
            Get.toNamed(AppRoute.matmCredoPage, arguments: true);
          } else if (isMatm) {
            Get.toNamed(AppRoute.matmTramopage);
          }
        }
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
              Get.toNamed(AppRoute.providerPage,
                  arguments: ProviderType.prepaid);
            },
            onPostpaidClick: () {
              Get.toNamed(AppRoute.providerPage,
                  arguments: ProviderType.postpaid);
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
      case HomeServiceType.virtualAccount:
        {
          Get.bottomSheet(VirtualAccountOptionDialog(
            onAccountView: () {
              Get.toNamed(AppRoute.virtualAccountPage);
            },
            onTransactionView: () {
              Get.toNamed(AppRoute.virtualAccountTransactionTabPage);
            },
          ));
        }
        break;
      case HomeServiceType.securityDeposity:
        {
          Get.toNamed(AppRoute.securityDepositPage);
        }
        break;
      case HomeServiceType.fundAddOnline:
        {
          Get.toNamed(AppRoute.addFundOnline);
        }
        break;
      case HomeServiceType.upiPayment:
        {
          Get.toNamed(AppRoute.upiPayment);
        }
        break;
      case HomeServiceType.cms:
        {
          Get.toNamed(AppRoute.cmsServicePage);
        }
        break;
      case HomeServiceType.newInvestment:
        {
          Get.toNamed(AppRoute.createInvestmentPage);
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
    await FirebaseCrashlytics.instance
        .setCustomKey("Mobile", appPreference.mobileNumber);
  }

  playNotificationSound() async {
    try {
      if (alertMessageObs.value.alert_no != null) {
        if (int.parse(alertMessageObs.value.alert_no!) > 0) {
          FlutterRingtonePlayer.play(
              fromAsset: "assets/sound/sound2.wav", looping: false);
        }
      }
    } catch (e) {}
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
  ott,
}
