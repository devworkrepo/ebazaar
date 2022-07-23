import 'package:get/get.dart';
import 'package:spayindia/data/repo/security_deposit_repo.dart';
import 'package:spayindia/data/repo/wallet_repo.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';

import '../../model/report/security_deposit.dart';

class SecurityDepositImpl extends SecurityDepositRepo{

  NetworkClient client = Get.find();


  @override
  Future<CommonResponse> addDeposit(data)  async{
    var response = await client.post("/AddSecurityDeposit",data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<SecurityDepositReportResponse> fetchReport(data) async {
    var response = await client.post("/GetDepositList",data: data);
    return SecurityDepositReportResponse.fromJson(response.data);
  }

}