import 'package:get/get.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/model/ott/ott_operator.dart';
import 'package:spayindia/model/ott/ott_plan.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';

class OttPlanController extends GetxController {
  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  OttOperator operator = Get.arguments["operator"];

  var planResponseObs = Resource.onInit(data: OttPlanResponse()).obs;
  late List<OttPlan> planList;

  @override
  void onInit() {
    super.onInit();
    _fetchPlan();
  }

  _fetchPlan() async {

    _onResponse(OttPlanResponse response){
      if(response.code == 1){
        planList = response.ottPlanList!;
      }
    }

    obsResponseHandler<OttPlanResponse>(
        obs: planResponseObs,
        apiCall: repo.fetchOttPlan({"ope_code" : operator.operatorCode ?? ""}),
        onResponse: _onResponse);

  }

  onItemTab(OttPlan plan) {
    Get.toNamed(AppRoute.ottTransactionPage,arguments: {
      "ott_plan" : plan,
      "operator" : operator
    });
  }
}
