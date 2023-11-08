import 'package:get/get.dart';
import 'package:ebazaar/data/repo/home_repo.dart';
import 'package:ebazaar/data/repo_impl/home_repo_impl.dart';
import 'package:ebazaar/model/common.dart';
import 'package:ebazaar/model/profile.dart';
import 'package:ebazaar/util/api/resource/resource.dart';
import 'package:ebazaar/util/future_util.dart';

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
