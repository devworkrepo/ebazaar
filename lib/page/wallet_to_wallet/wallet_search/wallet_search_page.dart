import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/image.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/wallet_to_wallet/wallet_search/wallet_search_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/app_constant.dart';

class WalletSearchPage extends GetView<WalletSearchController> {
  const WalletSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(WalletSearchController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet to Wallet"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (i){
              Get.toNamed(RouteName.fundReportPage);
            },

            itemBuilder: (BuildContext context) {
              return {'Report'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchSenderForm(),
          const Expanded(child: _BuildFavListWidget())
        ],
      ),
    );
  }

  _buildSearchSenderForm() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            //  key: controller.senderSearchFormkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.search),
                    Text(
                      "Search Retailer",
                      style: Get.textTheme.subtitle1
                          ?.copyWith(color: Get.theme.primaryColorDark),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                MobileTextField(
                  label: "Retailer Mobile Number",
                  onChange: controller.onMobileChange,
                  controller: controller.mobileController,
                  rightButton: Obx(() => (controller.showSearchButton.value)
                      ? (controller.isSearchingSender.value)
                          ? const CircularProgressIndicator()
                          : AppButton(
                              width: 100,
                              text: "Search",
                              onClick: () {
                                controller.searchWalletAccount();
                              })
                      : const SizedBox()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildFavListWidget extends GetView<WalletSearchController> {
  const _BuildFavListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
        () => controller.favListResponseObs.value.when(onSuccess: (data) {
              return _buildList();
            }, onFailure: (e) {
              return ExceptionPage(error: e);
            }, onInit: (data) {
              return ApiProgress(data);
            }));
  }

  Widget _buildList() {
    var list = controller.favList;
    var count = list.length;
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 8, left: 8, right: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Favourites",
                    style: Get.textTheme.headline6,
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: count,
                    itemBuilder: (context, index) {
                      return _buildListItem(list[index]);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListItem(WalletFav fav) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => controller.onFavItemClick(fav),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          children: [
            Row(
              children: [
                AppCircleNetworkImage(
                    AppConstant.profileBaseUrl + (fav.picName ?? "")),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fav.agentName ?? "",
                      style: Get.textTheme.subtitle1,
                    ),
                    Text(
                      fav.outletName ?? "",
                      style: Get.textTheme.bodyText1,
                    ),
                    Text(
                      "Mob : " + (fav.mobileNumber ?? ""),
                      style: Get.textTheme.bodyText1,
                    ),
                  ],
                )
              ],
            ),
            Divider()
          ],
        ),
      ),
    );
  }
}
