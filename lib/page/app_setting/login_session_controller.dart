import 'package:get/get.dart';
import 'package:ebazaar/data/app_pref.dart';
import 'package:ebazaar/data/repo_impl/home_repo_impl.dart';
import 'package:ebazaar/model/login_session.dart';
import 'package:ebazaar/page/exception_page.dart';
import 'package:ebazaar/route/route_name.dart';
import 'package:ebazaar/util/future_util.dart';
import 'package:ebazaar/widget/common/common_confirm_dialog.dart';
import 'package:ebazaar/widget/dialog/status_dialog.dart';

import '../../data/repo/home_repo.dart';
import '../../util/api/resource/resource.dart';

class AppSettingController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  AppPreference appPreference = Get.find();
  var responseObs = Resource.onInit(data: LoginSessionResponse()).obs;

  late List<LoginSession> sessions;


  @override
  void onInit() {
    super.onInit();
    _fetchLoginSessions();
  }

  _fetchLoginSessions() async {
    ObsResponseHandler<LoginSessionResponse>(
        obs: responseObs, apiCall: repo.fetchLoginSession(), result: (data) {
      sessions = data.sessions!;
        });
  }

  killSession(LoginSession session) async {

    Get.dialog(CommonConfirmDialogWidget(
      title: "Confirm Logout ? ",
        description: "Are you sure to logout from selected device!",
        onConfirm: (){
      _killSession(session);
    }));
  }

  _killSession(LoginSession session) async {
    try{
      StatusDialog.progress();
      var response = await repo.killSession({
        "active_id" : session.active_id.toString()
      });
      Get.back();
      if(response.code == 1){
        StatusDialog.success(title: response.message).then((value) {
          if(session.active_id == appPreference.sessionKey){
            appPreference.logout();
            Get.offAllNamed(AppRoute.loginPage);
          }
          else{
            _fetchLoginSessions();
          }
        });
      }
      else{
        StatusDialog.failure(title: response.message);
      }

    }catch(e){
      Get.back();
      Get.dialog(ExceptionPage(error: e));
    }
  }
}