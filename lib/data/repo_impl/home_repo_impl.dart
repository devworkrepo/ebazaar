import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/model/banner.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/news.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

import '../../model/notification.dart';

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
    var response = await client.post("/ChangeOTP",data : data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changePassword(data) async {
    var response = await client.post("/ChangePassword",data : data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> changePin(data) async {
    var response = await client.post("/ChangeMPIN",data : data);
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


}

