import 'package:spayindia/model/banner.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/profile.dart';
import 'package:spayindia/model/summary.dart';
import 'package:spayindia/model/user/user.dart';

import '../../model/notification.dart';

abstract class HomeRepo{

  Future<UserDetail> fetchAgentInfo();

  Future<BannerResponse> fetchBanners();

  Future<UserProfile> fetchProfileInfo();

  Future<TransactionSummary> fetchSummary();

  Future<NotificationResponse> fetchNotification();

  Future<UserBalance> fetchUserBalance();

  Future<CommonResponse> requestOtp(data);

  Future<CommonResponse> changePassword(data);

  Future<CommonResponse> changePin(data);
}