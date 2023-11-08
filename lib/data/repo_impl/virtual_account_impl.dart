import 'package:get/get.dart';
import 'package:ebazaar/data/repo/virtual_account_repo.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/virtual_account/virtual_account.dart';
import 'package:ebazaar/service/network_client.dart';

class VirtualAccountImpl extends VirtualAccountRepo {
  NetworkClient client = Get.find();

  @override
  Future<VirtualAccountDetailResponse> fetchVirtualAccounts() async {
    var response = await client.post("/GetVirtualAccounts");
    return VirtualAccountDetailResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addIciciVirtualAccount() async {
    var response = await client.post("/CreateICIAccount");
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> addYesVirtualAccount()  async{
    var response = await client.post("/CreateYESAccount");
    return CommonResponse.fromJson(response.data);
  }
}
