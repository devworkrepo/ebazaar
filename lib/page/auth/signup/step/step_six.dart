import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/validator.dart';

import '../../../../widget/text_field.dart';
import '../signup_controller.dart';

class SingUpStepSixWidget extends GetView<SignupController> {
  const SingUpStepSixWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verify Your Aadhaar Details",
          style: Get.textTheme.headline6,
        ),
        Container(
          margin: EdgeInsets.only(top: 12),
          padding: EdgeInsets.all(6),
          decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1)),
          child: Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all()
                  ),
                  child: Image.asset(
                    "assets/image/complaint.jpeg",
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
                            title: "Name", value: "Akash Kumar Das"),
                        _TitleValueWidget(title: "DOB", value: "04-05-1998"),
                        _TitleValueWidget(title: "Gender", value: "Male"),
                        _TitleValueWidget(
                            title: "Address",
                            value:
                                "H. No. 315, 2nd Floor Niti Khand -3 Indirapuram Ghaziabad"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
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
            Expanded(child: Text(title),flex: 1,),
            Text( "  :  "),
            Expanded(
              flex: 2,
                child: Text(
              value,
              textAlign: TextAlign.start,
              style: Get.textTheme.caption?.copyWith(fontWeight: FontWeight.w500),
            )),
          ],
        ),
        Divider(indent: 0,color: Colors.grey.shade300,)
      ],
    );
  }
}
