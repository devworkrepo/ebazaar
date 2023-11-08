import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/user/signup/mobile_submit.dart';
import 'package:ebazaar/model/wallet/wallet_fav.dart';

abstract class WalletRepo{
  Future<WalletFavListResponse> fetchFavList();
  Future<WalletSearchResponse> searchWallet(data);
  Future<CommonResponse> deleteFav(data);
  Future<WalletTransactionResponse> walletTransfer(data);
}