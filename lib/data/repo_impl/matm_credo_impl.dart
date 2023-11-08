import 'package:get/get.dart';
import 'package:ebazaar/data/repo/matm_credo_repo.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/service/network_client.dart';

import '../../model/matm_credo/matm_credo_initiate.dart';

class MatmCredoImpl extends MatmCredoRepo {
  var client = Get.find<NetworkClient>();

  @override
  Future<MatmCredoInitiate> initiateMATMTransaction(data) async {
    var response = await client.post("/MatmTransactionCredo", data: data);
    return MatmCredoInitiate.fromJson(response.data);
  }

  @override
  Future<CommonResponse> updateTransactionToServer(data) async {
    var response = await client.post("/MatmTransactionUpdate", data: data);
    return CommonResponse.fromJson(response.data);
  }

  @override
  Future<MatmCredoInitiate> initiateMPOSTransaction(data) async {
    var response = await client.post("/MPosTransactionCredo", data: data);
    return MatmCredoInitiate.fromJson(response.data);
  }

  @override
  Future<MatmCredoInitiate> initiateVOIDTransaction(data) async {
    var response = await client.post("/MPosVoidCredo", data: data);
    return MatmCredoInitiate.fromJson(response.data);
  }
}
