import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/wallet_repo.dart';
import 'package:spayindia/data/repo_impl/wallet_repo_impl.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';

class WalletSearchController extends GetxController{

  WalletRepo repo = Get.find<WalletRepoImpl>();

  var mobileController = TextEditingController();
  var showSearchButton = false.obs;
  var isSearchingSender = false.obs;

  var favListResponseObs = Resource.onInit(data: WalletFavListResponse()).obs;
  late List<WalletFav> favList;

  @override
  void onInit() {
    super.onInit();

    _fetchFavList();
  }


  _fetchFavList() async{
    try{
      favListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchFavList();
      favList = response.favList!;
      favListResponseObs.value = Resource.onSuccess(response);
    }catch(e){
      favListResponseObs.value = Resource.onFailure(e);
    }
  }

  searchWalletAccount() async{
    try{
      StatusDialog.progress(title: "Searching...");
      var response = await repo.searchWallet({
        "mobileno" : mobileController.text
      });
      Get.back();

      if(response.code == 1){
        Get.toNamed(AppRoute.walletTransferPage,arguments: response);
      }
      else{
        StatusDialog.failure(title: response.message);
      }


    }catch(e){
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  onMobileChange(String value) {
    final mobileNumber = mobileController.text.toString();

    if (mobileNumber.length == 10) {
      showSearchButton.value = true;
      searchWalletAccount();

    } else {
      showSearchButton.value = false;
    }
  }

  onFavItemClick(WalletFav fav) {

    if(fav.mobileNumber != null){
      if(fav.mobileNumber!.length == 10){
        mobileController.text = fav.mobileNumber!;
        showSearchButton.value = true;
        if(isSearchingSender.isFalse){
          searchWalletAccount();
        }
      }
    }
  }
}