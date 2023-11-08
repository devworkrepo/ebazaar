import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ebazaar/data/app_pref.dart';
import 'package:ebazaar/data/repo/home_repo.dart';
import 'package:ebazaar/data/repo/recharge_repo.dart';
import 'package:ebazaar/model/alert.dart';
import 'package:ebazaar/model/app_update.dart';
import 'package:ebazaar/model/banner.dart';
import 'package:ebazaar/model/cms_service.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/login_session.dart';
import 'package:ebazaar/model/news.dart';
import 'package:ebazaar/model/recharge/provider.dart';
import 'package:ebazaar/model/summary.dart';
import 'package:ebazaar/model/user/user.dart';
import 'package:ebazaar/service/network_client.dart';
import 'package:ebazaar/util/app_util.dart';

import '../../model/notification.dart';
import '../../model/profile.dart';
import '../../widget/dialog/status_dialog.dart';

class HomeRepoImpl extends HomeRepo {
  final NetworkClient client = Get.find();
  final AppPreference appPreference = Get.find();

  @override
  Future<UserBalance> fetchUserBalance() async {
    var response = await client.get("user/balance");
    return UserBalance.fromJson(response.data);
  }

  @override
  Future<UserDetail> fetchAgentInfo() async {
    var response = await client.post("GetAgentInfo");
    // var response = await AppUtil.parseJsonFromAssets("agent_info_response");
    return UserDetail.fromJson(response.data);
  }

  @override
  Future<CommonResponse> requestOtp(data) async {
    var response = await client.post("/ChangeOTP", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changePassword(data) async {
    var response = await client.post("/ChangePassword", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changePin(data) async {
    var response = await client.post("/ChangeMPIN", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<BannerResponse> fetchBanners() async {
    var response = await client.post("/GetBanners");
    return BannerResponse.fromJson(response.data);
  }

  @override
  Future<NotificationResponse> fetchNotification() async {
    var response = await client.post("/GetNotifications");
    return NotificationResponse.fromJson(response.data);
  }

  @override
  Future<UserProfile> fetchProfileInfo() async {
    var response = await client.post("/GetAgentProfile");
    return UserProfile.fromJson(response.data);
  }

  @override
  Future<TransactionSummary> fetchSummary() async {
    var response = await client.post("/GetTransSummary");
    return TransactionSummary.fromJson(response.data);
  }

  @override
  Future<LoginSessionResponse> fetchLoginSession() async {
    var response = await client.post("/GetActiveSessions");
    return LoginSessionResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> killSession(data) async {
    var response = await client.post("/KillSession", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> logout() async {
    var response = await client.post("/Logout");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<NetworkAppUpdateInfo> updateInfo() async {
    var response = await client.get("/CheckAppUpdates");
    return NetworkAppUpdateInfo.fromJson(response.data);
  }

  @override
  Future<CommonResponse> getTransactionNumber() async {
    var response = await client.post(
      "/GetTransactionNo",
    );
    return CommonResponse.fromJson(response.data);
  }


  @override
  Future<void> downloadFileAndSaveToGallery(
      String baseUrl, String extension) async {
    try {
      Dio dio = Dio();
      var dir = await getApplicationDocumentsDirectory();
      var imageDownloadPath = '${dir.path}/$extension';

      StatusDialog.progress(title: "Downloading...");
      await dio.download(baseUrl + extension, imageDownloadPath,
          onReceiveProgress: (received, total) {
        var progress = (received / total) * 100;

        if (progress == 100.0) {
          if (Get.isDialogOpen!) {
            Get.back();
            StatusDialog.success(
                    title: "File Downloaded and\n saved to Gallery")
                .then((value) =>
                    OpenFile.open(imageDownloadPath, type: "image/*"));
          }
        }
      });
      ImageGallerySaver.saveFile(imageDownloadPath);
    } catch (e) {
      Get.back();
      StatusDialog.failure(title: "Failed to download file");
    }

  }

  @override
  Future<AlertMessageResponse> alertMessage() async {
/*   var a  =await AppUtil.parseJsonFromAssets("alert");
    return AlertMessageResponse.fromJson(a);*/
    var response = await client.post("/GetAlertBell");
    return AlertMessageResponse.fromJson(response.data);
  }

  @override
  Future<CmsServiceResponse> cmsService() async{
    var response = await client.post("/CMSTransaction");
    return CmsServiceResponse.fromJson(response.data);
  }
}
