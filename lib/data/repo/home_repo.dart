import 'package:spayindia/model/banner.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/user/user.dart';

abstract class HomeRepo{

  Future<UserDetail> fetchAgentInfo();

  Future<BannerResponse> fetchBanners();
  Future<BannerResponse> fetchNotification();

  Future<UserBalance> fetchUserBalance();

  Future<CommonResponse> requestOtp(data);

  Future<CommonResponse> changePassword(data);

  Future<CommonResponse> changePin(data);
}