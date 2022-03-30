import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/news.dart';
import 'package:spayindia/model/user/user.dart';

abstract class HomeRepo{

  Future<UserDetail> fetchAgentInfo();

  Future<NewsResponse> fetchNews();

  Future<UserBalance> fetchUserBalance();

  Future<StatusMessageResponse> verifyPin(data);

  Future<StatusMessageResponse> changePassword(data);

  Future<StatusMessageResponse> requestOtpForGenerateMPin();

  Future<StatusMessageResponse> verifyGenerateMPin(data);

}