import 'package:get/get.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';

import '../../model/summary.dart';

class SummaryController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  var responseObs = Resource.onInit(data: TransactionSummary()).obs;
  late TransactionSummary summary;

  @override
  void onInit() {
    super.onInit();
    _fetchSummary();
  }

  _fetchSummary() async {
    ObsResponseHandler<TransactionSummary>(
        obs: responseObs, apiCall: repo.fetchSummary(), result: (data) {
          summary = data;
    });
  }
}
