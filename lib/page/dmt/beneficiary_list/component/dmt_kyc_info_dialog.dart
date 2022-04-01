import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/image.dart';
import 'package:spayindia/model/dmt/kyc_info.dart';
import 'package:spayindia/page/recharge/recharge/component/recharge_confirm_dialog.dart';

class DmtKycInfoDialog extends StatelessWidget {
  final KycInfoResponse response;

  const DmtKycInfoDialog(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "Kyc Detail",
                    style: Get.textTheme.headline1?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: Get.width,
                      child: Column(
                        children: [
                          AppCircleNetworkImage(
                            response.picName.toString(),
                            size: 80,
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          BuildTitleValueWidget(
                              title: "Name", value: response.name.toString()),
                          BuildTitleValueWidget(
                              title: "Date of Birth",
                              value: response.dob.toString()),
                          BuildTitleValueWidget(
                              title: "Gender",
                              value: (response.gender.toString() == "M")
                                  ? "Male"
                                  : "Female"),
                          BuildTitleValueWidget(
                              title: "Aadhaar Number",
                              value: response.aadhaarNumber.toString()),
                          BuildTitleValueWidget(
                              title: "Address",
                              value: response.address.toString()),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.cancel,
                  color: Colors.black45,
                  size: 60,
                )),
          )
        ],
      ),
    );
  }
}
