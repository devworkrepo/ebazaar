import 'package:get/get.dart';
import 'package:spayindia/data/repo/dmt_repo.dart';
import 'package:spayindia/data/repo_impl/dmt_repo_impl.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';

import '../../../model/dmt/kyc_info.dart';
import '../dmt.dart';

class SenderKycInfoController extends GetxController {
  DmtRepo repo = Get.find<DmtRepoImpl>();
  String senderMobileNumber = Get.arguments["mobile_number"];
  DmtType dmtType = Get.arguments["dmt_type"];
  bool fromKyc = Get.arguments["from_kyc"] ?? false;

  var responseObs = Resource.onInit(data: KycInfoResponse()).obs;
  late KycInfoResponse kycInfoResponse;

  @override
  void onInit() {
    super.onInit();
    _fetchKycInfo();
  }

  _fetchKycInfo() async {
    ObsResponseHandler<KycInfoResponse>(
        obs: responseObs,
        apiCall: repo.kycInfo({
          "mobileno": senderMobileNumber,
        }),
        result: (data) {
          kycInfoResponse = data;
        });
  }
}
