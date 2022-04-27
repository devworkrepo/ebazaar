import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';
import 'package:spayindia/model/login_session.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/util/future_util.dart';
import 'package:spayindia/widget/common/common_confirm_dialog.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

import '../../data/repo/home_repo.dart';
import '../../util/api/resource/resource.dart';

class AppSettingController extends GetxController {
  HomeRepo repo = Get.find<HomeRepoImpl>();

  AppPreference appPreference = Get.find();
  var responseObs = Resource.onInit(data: LoginSessionResponse()).obs;

  late List<LoginSession> _sessions;
  List<LoginSession> getLoginSessionList() {
   return  _sessions.where((element) => element.active_id != appPreference.sessionKey).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _fetchLoginSessions();
  }

  _fetchLoginSessions() async {
    ObsResponseHandler<LoginSessionResponse>(
        obs: responseObs, apiCall: repo.fetchLoginSession(), result: (data) {
      _sessions = data.sessions!;
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
        StatusDialog.success(title: response.message).then((value) => _fetchLoginSessions());
      }
      else{
        StatusDialog.failure(title: response.message);
      }

    }catch(e){
      Get.back();
      Get.to(()=>ExceptionPage(error: e));
    }
  }
}