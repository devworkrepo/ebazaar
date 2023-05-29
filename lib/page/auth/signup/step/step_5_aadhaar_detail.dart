import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/app_constant.dart';
import 'package:spayindia/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class StepAadhaarDetail extends GetView<SignupController> {
  const StepAadhaarDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify Your Aadhaar Details",
          style: Get.textTheme.headline6,
        ),
        Obx(() {

          var isFetched = controller.detailFetched.value;

          return (!isFetched) ? const SizedBox()
              : Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
            child: Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all()
                    ),
                    child: Image.network(
                      controller.aadhaarDetail.picname.toString(),
                      width: 80,

                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _TitleValueWidget(
                              title: "Name", value: controller.aadhaarDetail.name ?? ""),
                          _TitleValueWidget(title: "DOB", value: controller.aadhaarDetail.dob ?? ""),
                          _TitleValueWidget(title: "Gender", value: controller.aadhaarDetail.gender ?? ""),
                          _TitleValueWidget(
                              title: "Address",
                              value: controller.aadhaarDetail.address ?? ""),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }),
        const SizedBox(
          height: 32,
        ),
      ],
    );
  }
}

class _TitleValueWidget extends StatelessWidget {
  final String title;
  final String value;

  const _TitleValueWidget({required this.title, required this.value, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(title), flex: 1,),
            Text("  :  "),
            Expanded(
                flex: 2,
                child: Text(
                  value,
                  textAlign: TextAlign.start,
                  style: Get.textTheme.caption?.copyWith(
                      fontWeight: FontWeight.w500),
                )),
          ],
        ),
        Divider(indent: 0, color: Colors.grey.shade300,)
      ],
    );
  }
}
