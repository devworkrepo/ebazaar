import 'package:get/get.dart';
import 'package:ebazaar/data/repo/recharge_repo.dart';
import 'package:ebazaar/data/repo_impl/recharge_repo_impl.dart';
import 'package:ebazaar/model/ott/ott_operator.dart';
import 'package:ebazaar/model/ott/ott_plan.dart';
import 'package:ebazaar/route/route_name.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/future_util.dart';
import 'package:ebazaar/widget/dialog/status_dialog.dart';

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

    try{
      planResponseObs.value = const Resource.onInit();
      var response = await repo.fetchOttPlan({"ope_code" : operator.operatorCode ?? ""});
      if (response.code == 1) {
        planResponseObs.value = Resource.onSuccess(response);
        planList = response.ottPlanList!;
      } else {
        StatusDialog.failure(
            title: response.message ?? "Something went wrong!!")
            .then((value) => Get.back());
      }

    }catch(e){
      StatusDialog.failure(
          title: "Something went wrong!!")
          .then((value) => Get.back());
    }

  }

  onItemTab(OttPlan plan) {
    Get.toNamed(AppRoute.ottTransactionPage,arguments: {
      "ott_plan" : plan,
      "operator" : operator
    });
  }
}
