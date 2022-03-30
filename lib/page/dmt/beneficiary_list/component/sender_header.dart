import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/res/color.dart';
import 'package:spayindia/util/hex_color.dart';

import '../beneficiary_controller.dart';

class BeneficiarySenderHeader extends GetView<BeneficiaryListController> {
  final VoidCallback onClick;
  final String mobileNumber;
  final String senderName;
  final String limit;

  const BeneficiarySenderHeader(
      {Key? key,
      required this.onClick,
      required this.mobileNumber,
      required this.senderName,
      required this.limit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {


    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white70),
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.only(
          top: statusBarHeight + kToolbarHeight, left: 8, right: 8, bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //_buildCircularAvatar(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildName(senderName),
                  _buildName(mobileNumber),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildChangeWidget()
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Available Limit",
                  style:
                      Get.textTheme.subtitle1?.copyWith(color: Colors.white70),
                ),
                Obx(() => controller.showAvailableTransferLimitObs.value == true
                    ? Text(
                  "₹ ${(controller.sender!.isKycVerified!) ? controller.sender?.impsKycLimitView : controller.sender?.impsNKycLimitView}",
                        style: Get.textTheme.headline3
                            ?.copyWith(color: Colors.green),
                      )
                    : _buildViewLimitContainer()),
                (!controller.sender!.isKycVerified!)
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          "non-kyc",
                          style: TextStyle(color: Colors.red.shade400),
                        ))
                    : const SizedBox()
              ],
            )
            // _buildAddBeneButton()
          ],
        ),
      ),
    );
  }

  Widget _buildViewLimitContainer() {
    return GestureDetector(
      onTap: () => controller.showAvailableTransferLimit(),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: 120,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey, width: 1)),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.remove_red_eye,
                color: Colors.white,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "View Limit",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangeWidget() {
    var style =
        TextStyle(fontWeight: FontWeight.w500, color: HexColor("2ebf14"));
    return Wrap(
      children: [
        GestureDetector(
          onTap: () => controller.onNameChange(),
          child: Text(
            "[ Change Name ]",
            style: style,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        GestureDetector(
          onTap: ()=>controller.onMobileChange(),
          child: Text(
            "[ Change Mobile ]",
            style: style,
          ),
        ),
      ],
    );
  }

  Row _buildIconTitle({required IconData icon, required String title}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          title,
          style: Get.textTheme.subtitle2?.copyWith(color: Colors.grey[700]),
        )
      ],
    );
  }

  Text _buildName(String senderName) {
    return Text(
      senderName,
      style: Get.textTheme.headline6?.copyWith(color: Colors.white),
    );
  }

  CircleAvatar _buildCircularAvatar() {
    return CircleAvatar(
      backgroundColor: AppColor.backgroundColor,
      radius: 30,
      child: const Icon(
        Icons.person,
        size: 40,
      ),
    );
  }

  _buildAddBeneButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FloatingActionButton(
          elevation: 1,
          mini: true,
          backgroundColor: Colors.green,
          onPressed: onClick,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        const Text(
          "Add New\nBeneficiary",
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
