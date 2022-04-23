import 'package:get/get.dart';
import 'package:spayindia/data/repo/home_repo.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/profile.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/future_util.dart';

class ProfileController extends GetxController {
  var responseObs = Resource.onInit(data: UserProfile()).obs;
  HomeRepo repo = Get.find<HomeRepoImpl>();

  @override
  void onInit() {
    super.onInit();
    _fetchProfileInfo();
  }

  _fetchProfileInfo() async {
    ObsResponseHandler(obs: responseObs, apiCall: repo.fetchProfileInfo());
  }
}
