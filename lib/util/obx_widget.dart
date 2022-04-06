import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/api_component.dart';
import '../page/exception_page.dart';
import 'api/resource/resource.dart';

class ObsResourceWidget<T> extends StatelessWidget {
  final Rx<Resource<T>> obs;
  final Widget Function(T data) childBuilder;


  const ObsResourceWidget({Key? key, required this.obs,required this.childBuilder,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => obs.value.when(onSuccess: (data) {
          dynamic response = data;
          if (response.code == 1) {
               return childBuilder(data);
          } else {
            return ExceptionPage(error: Exception(response.message));
          }
        }, onFailure: (e) {
          return ExceptionPage(
            error: e,
          );
        }, onInit: (data) {
          return ApiProgress(data);
        }));
  }
}


class ConditionalWidget extends StatelessWidget {
  final bool condition;
  final Widget child;
  const ConditionalWidget({required this.condition,required this.child,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (condition)  ? child : const SizedBox();
  }
}




