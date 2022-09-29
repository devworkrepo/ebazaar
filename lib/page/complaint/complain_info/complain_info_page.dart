import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/model/complaint.dart';
import 'package:spayindia/page/complaint/complain_info/complain_info_controller.dart';
import 'package:spayindia/widget/text_field.dart';

import '../../../util/app_constant.dart';
import 'complain_message_list.dart';

class ComplainInfoPage extends GetView<ComplainInfoController> {
  const ComplainInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ComplainInfoController());
    if (MediaQuery.of(context).viewInsets.bottom == 0) {
      controller.isKeyboardOpen.value = false;
    } else {
      controller.isKeyboardOpen.value = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complain Details"),
      ),
      body: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Column(
          children: [
            if (!controller.isKeyboardOpen.value) _buildInfoSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Comments",
                    style: Get.textTheme.headline5
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )),
            ),
            _listSection(),

            buildAddComment(),
            //  Expanded(child: const ComplainMessageListWidget()),
          ],
        ),
      ),
    );
  }

  Expanded _listSection() {
    return Expanded(
        child: Obx(() => ListView.builder(
            padding: EdgeInsets.only(bottom: 60),
            controller: controller.commentListController,
            itemCount: controller.commentsObs.length,
            reverse: true,
            itemBuilder: (context, index) {
              ComplaintComment comment = controller.commentsObs[index];
              return _itemChat(
                  context: context,
                  chat: 1,
                  message: comment.replydesc!,
                  time: comment.addeddate);
            })));
  }

  Container buildAddComment() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(),
          color: Colors.white70),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 20.0,
            backgroundImage: NetworkImage(AppConstant.profileBaseUrl +
                controller.appPreference.user.picName.toString()),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(
            width: 12,
          ),
          Expanded(
              child: TextField(
            controller: controller.textController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Hi..",
            ),
          )),

          /*
                ),*/
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30))),
              onPressed: () {
                controller.addReply();
              },
              child: Icon(
                Icons.send,
                color: Colors.blue,
              ))
        ],
      ),
    );
  }

  _itemChat(
      {required BuildContext context,
      required int chat,
      required message,
      time}) {
    return Row(
      mainAxisAlignment:
          chat == 0 ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (chat == 0)
          SizedBox(
            width: 100,
          ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: chat == 0 ? Colors.indigo.shade50 : Colors.grey.shade200,
              borderRadius: chat == 0
                  ? BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
            ),
            child: Column(
              crossAxisAlignment: (chat == 1)
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Text(
                  '$message',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '$time',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ),
        if (chat == 1)
          SizedBox(
            width: 100,
          ),
      ],
    );
  }

  Widget _buildInfoSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset("assets/image/arr.png"),
              Text(
                "Ticket# ${controller.complain.ticket_no}",
                style: Get.textTheme.headline6,
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.yellow[800]),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: const Text(
              "1",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          _buildTitleValue(
              "Created Date", controller.complain.addeddate.toString()),
          _buildTitleValue("Status", controller.complain.status.toString()),
          _buildTitleValue(
              "Transaction No.", controller.complain.transaction_no.toString()),
          _buildTitleValue("Message", controller.complain.full_desc.toString()),
        ],
      ),
    );
  }

  Widget _buildTitleValue(String title, String value) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  title,
                  style: Get.textTheme.labelLarge,
                )),
            const Text("  :  "),
            Expanded(
                flex: 2,
                child: Text(
                  value,
                  style: Get.textTheme.labelLarge
                      ?.copyWith(color: Colors.grey[800]),
                ))
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        const Divider(
          indent: 0,
        )
      ],
    );
  }
}
