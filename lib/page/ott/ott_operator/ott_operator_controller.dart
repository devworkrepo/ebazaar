import 'package:get/get.dart';
import 'package:ebazaar/data/repo/recharge_repo.dart';
import 'package:ebazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:ebazaar/model/ott/ott_operator.dart';
import 'package:ebazaar/route/route_name.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/future_util.dart';

class OttOperatorController extends GetxController {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  var operatorsResponseObs =
      Resource.onInit(data: OttOperatorListResponse()).obs;
  late List<OttOperator> operatorList;

  @override
  void onInit() {
    super.onInit();
    _fetchOperators();
  }

  _fetchOperators() async {

    _onResponse(OttOperatorListResponse response){
      if(response.code == 1){
        operatorList = response.operators!;
      }
    }

    obsResponseHandler<OttOperatorListResponse>(
        obs: operatorsResponseObs,
        apiCall: repo.fetchOttOperators(),
        onResponse: _onResponse);

  }

  onItemTap(OttOperator operator) {
    Get.toNamed(AppRoute.ottPlanPage,arguments: {
      "operator" : operator
    });
  }
}
