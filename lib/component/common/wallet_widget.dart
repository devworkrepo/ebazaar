import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';

class WalletWidget extends GetView<_WalletWidgetController> {
  const WalletWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(_WalletWidgetController());
    return SizedBox(
      width: Get.width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Debited From',
                style:
                    Get.textTheme.subtitle1?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Icon(
                    Icons.account_balance_wallet,
                    color: Get.theme.primaryColorDark,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Spay India wallet",
                            style: Get.textTheme.subtitle1
                                ?.copyWith(color: Get.theme.primaryColorDark),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Obx(() => Text(
                                "Available Balance :  Rs. ${controller.balance.value}",
                                style: TextStyle(
                                    color: Get.theme.primaryColorLight,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ))
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletWidgetController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();
  AppPreference appPreference = Get.find();

  var balance = "".obs;

  @override
  void onInit() {
    super.onInit();
    balance.value = appPreference.user.availableBalance.toString();
    // _fetchBalance();
  }

  _fetchBalance() async {
    try {
      var response = await repo.fetchUserBalance();
      if (response.status == 1) {
       // appPreference.setBalance(response);
        //  balance.value = response;
      } else {
        Get.snackbar("User Balance", "Unable to fetch user balance",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("User Balance", "Unable to fetch user balance",
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
