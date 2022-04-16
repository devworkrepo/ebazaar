import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/no_data_found.dart';
import 'package:spayindia/model/notification.dart';
import 'package:spayindia/page/notification/notification_controller.dart';
import 'package:spayindia/util/obx_widget.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        centerTitle: true,
        title: const Text(
          "Notifications",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: ObsResourceWidget(
          obs: controller.responseObs, childBuilder: (data) => _BuildBody()),
    );
  }
}

class _BuildBody extends GetView<NotificationController> {
  @override
  Widget build(BuildContext context) {
    return (controller.notifications.isEmpty)
        ? const NoItemFoundWidget()
        : ListView.builder(
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) =>
                _BuildListItem(controller.notifications[index]));
  }
}

class _BuildListItem extends StatelessWidget {
  final AppNotification notification;

  const _BuildListItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Card(
        color: Get.theme.primaryColor,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title ?? "",
                style: Get.textTheme.headline5
                    ?.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
              ),
              Text(
                notification.description ?? "",
                style: Get.textTheme.bodyText1?.copyWith(color: Colors.white70),
              )
            ],
          ),
        ),
      ),
    );
  }
}
