import 'package:get/get.dart';
import 'package:spayindia/data/repo/wallet_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

class WalletRepoImpl extends WalletRepo{

  NetworkClient client = Get.find();


  @override
  Future<WalletFavListResponse> fetchFavList()  async{
    var response = await client.post("/GetWalletFavList");
    return WalletFavListResponse.fromJson(response.data);
  }

  @override
  Future<WalletSearchResponse> searchWallet(data) async {
    var response = await client.post("/SearchWalletAccount",data: data);
    return WalletSearchResponse.fromJson(response.data);
  }

  @override
  Future<WalletTransactionResponse> walletTransfer(data) async {
    var response = await client.post("/WalletTransaction",data: data);
    return WalletTransactionResponse.fromJson(response.data);
  }


}