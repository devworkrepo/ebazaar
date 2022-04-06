import 'package:get/get.dart';

import '../page/exception_page.dart';
import 'api/resource/resource.dart';

obsResponseHandler<T>(
    {required Rx<Resource<T>> obs,
    required Future apiCall,
    required Function(T) onResponse}) async {
  obs.value = const Resource.onInit();
  try {
    T response = await apiCall;
    onResponse(response);
    obs.value = Resource.onSuccess(response);
  } catch (e) {
    obs.value = Resource.onFailure(e);
    Get.off(ExceptionPage(error: e));
  }
}
