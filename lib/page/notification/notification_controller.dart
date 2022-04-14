import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:spayindia/data/repo_impl/home_repo_impl.dart';

import '../../data/repo/home_repo.dart';

class NotificationController extends GetxController{

  HomeRepo repo = Get.find<HomeRepoImpl>();

  @override
  void onInit() {
    super.onInit();
    _fetchNotifications();

  }

  _fetchNotifications() async{

    var response = repo.fetchNotification();

  }

}