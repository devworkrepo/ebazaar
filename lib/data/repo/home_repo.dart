import 'package:spayindia/model/banner.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/login_session.dart';
import 'package:spayindia/model/profile.dart';
import 'package:spayindia/model/summary.dart';
import 'package:spayindia/model/user/user.dart';

import '../../model/alert.dart';
import '../../model/app_update.dart';
import '../../model/notification.dart';

abstract class HomeRepo{

  Future<UserDetail> fetchAgentInfo();

  Future<BannerResponse> fetchBanners();

  Future<UserProfile> fetchProfileInfo();

  Future<TransactionSummary> fetchSummary();

  Future<LoginSessionResponse> fetchLoginSession();
  Future<CommonResponse> killSession(data);
  Future<CommonResponse> logout();

  Future<NotificationResponse> fetchNotification();

  Future<UserBalance> fetchUserBalance();

  Future<CommonResponse> requestOtp(data);

  Future<CommonResponse> changePassword(data);

  Future<CommonResponse> changePin(data);
  Future<NetworkAppUpdateInfo> updateInfo();

  Future<CommonResponse> getTransactionNumber();

  Future<void> downloadFileAndSaveToGallery(String baseUrl, String extension);

  Future<AlertMessageResponse> alertMessage();
}