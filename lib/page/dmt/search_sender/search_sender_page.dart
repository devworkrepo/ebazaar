import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/radio.dart';
import 'package:spayindia/component/text_field.dart';
import 'package:spayindia/page/dmt/dmt.dart';
import 'package:spayindia/page/dmt/search_sender/search_sender_controller.dart';

DmtSearchSenderController? dmtSearchSenderController;

class DmtSearchSenderPage extends GetView<DmtSearchSenderController> {
  const DmtSearchSenderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Get.put( DmtSearchSenderController());

    dmtSearchSenderController = controller;
    return Scaffold(
      appBar: AppBar(
        title: Text(DmtHelper.getAppbarTitle(controller.dmtType)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildSearchTypeWidget(),
            _buildSearchSenderForm(),
          ],
        ),
      ),
    );
  }

  _buildSearchSenderForm() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 16, right: 8, left: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            //  key: controller.senderSearchFormkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() => Row(
                      children: [
                        Icon(
                          (DmtRemitterSearchType.mobile ==
                                  controller.searchTypeObs.value)
                              ? Icons.mobile_friendly
                              : Icons.account_balance,
                          color: Get.theme.primaryColorDark,
                          size: 20,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          (DmtRemitterSearchType.mobile == controller.searchTypeObs.value)? "Search Remitter" : "Search Account",
                          style: Get.textTheme.headline6,
                        )
                      ],
                    )),
                const SizedBox(
                  height: 8,
                ),
               Obx(()=> AppTextField(
                 maxLength: controller.getInputTextFielMaxLegth(),
                 inputType: TextInputType.number,
                 label: controller.getInputTextFieldLabel(),
                 onChange: controller.onMobileChange,
                 controller: controller.numberController,
                 rightButton: (controller.showSearchButton.value)
                     ? (controller.isSearchingSender.value)
                     ? const CircularProgressIndicator()
                     : AppButton(
                                  width: 100,
                                  text: "Search",
                                  onClick: () {
                                    controller.onSearchClick();
                                  })
                          : const SizedBox(),
               )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildSearchTypeWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: Get.width,
        child: Card(

          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              //  key: controller.senderSearchFormkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Search Type",
                    style: Get.textTheme.headline6,
                  ),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: AppRadioButton(
                                groupValue: controller.searchTypeObs.value,
                                value: DmtRemitterSearchType.mobile,
                                title: "Mobile",
                                onChange: (value) {
                                  controller.searchTypeObs.value =
                                      value as DmtRemitterSearchType;
                                }),
                          ),
                          Expanded(
                            child: AppRadioButton(
                                groupValue: controller.searchTypeObs.value,
                                value: DmtRemitterSearchType.account,
                                title: "Account",
                                onChange: (value) {
                                  controller.searchTypeObs.value =
                                      value as DmtRemitterSearchType;
                                }),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
