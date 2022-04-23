import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/image.dart';
import 'package:spayindia/page/dmt/kyc_info/sender_kyc_info_controller.dart';
import 'package:spayindia/page/dmt/sender_kcy/sender_kyc_controller.dart';
import 'package:spayindia/page/recharge/recharge/component/recharge_confirm_dialog.dart';
import 'package:spayindia/util/obx_widget.dart';

import '../../../route/route_name.dart';

class SenderKycInfoPage extends GetView<SenderKycInfoController> {
  const SenderKycInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SenderKycInfoController());
    return WillPopScope(
      onWillPop: () async{
        if(controller.fromKyc){
           Get.offAllNamed(AppRoute.mainPage);
           return  false;
        }
        else{
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Sender Kyc Info"),),
        body: ObsResourceWidget(
            obs: controller.responseObs,
            childBuilder: (data) => SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Kyc Detail",
                      style: Get.textTheme.headline1?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                              controller.kycInfoResponse.picName.toString(),
                              size: 80,
                            ),
                            SizedBox(
                              height: 32,
                            ),
                            BuildTitleValueWidget(
                                title: "Name",
                                value:  controller.kycInfoResponse.name.toString()),
                            BuildTitleValueWidget(
                                title: "Date of Birth",
                                value:  controller.kycInfoResponse.dob.toString()),
                            BuildTitleValueWidget(
                                title: "Gender",
                                value:
                                ( controller.kycInfoResponse.gender.toString() == "M")
                                    ? "Male"
                                    : "Female"),
                            BuildTitleValueWidget(
                                title: "Aadhaar Number",
                                value:
                                controller.kycInfoResponse.aadhaarNumber.toString()),
                            BuildTitleValueWidget(
                                title: "Address",
                                value:  controller.kycInfoResponse.address.toString()),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
