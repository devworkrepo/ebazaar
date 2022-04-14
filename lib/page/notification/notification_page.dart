import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/page/notification/notification_controller.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Scaffold(

      appBar: AppBar(
        foregroundColor: Get.theme.primaryColorDark,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Notifications",style: TextStyle(fontSize: 24),),
      ),
      body: Text(""),
    );
  }
}
