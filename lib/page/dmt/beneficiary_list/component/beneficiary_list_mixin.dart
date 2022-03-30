import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/res/color.dart';

mixin BeneficiaryListMixin {
  Widget buildAvatar(bool isBankVerified) {
    return CircleAvatar(
      backgroundColor: AppColor.backgroundColor,
      radius: 20,
      child: Icon(
        Icons.person,
        color: (isBankVerified) ? Colors.green : Colors.black,
        size: 28,
      ),
    );
  }

  Widget buildDmtContent({
    required bool isExpanded,
    required bool isBankVerified,
    required String? beneficiaryName,
    required String? accountNumber,
    required String? bankName,
    required String? ifscCode,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              (isBankVerified)
                  ? const Icon(
                      Icons.verified,
                      color: Colors.green,
                      size: 16,
                    )
                  : const SizedBox(),
              Expanded(
                child: Text(
                  beneficiaryName ?? "N/A",
                  style: Get.textTheme.headline6?.copyWith(
                      fontSize: 15,
                      color: (isExpanded)
                          ? Colors.white
                          : (isBankVerified)
                              ? Get.theme.primaryColorDark
                              : Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            bankName ?? "N/A",
            style: Get.textTheme.subtitle2?.copyWith(
                color: (isExpanded) ? Colors.white70 : Colors.black54),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            accountNumber ?? "N/A",
            style: Get.textTheme.subtitle2?.copyWith(
                color: (isExpanded) ? Colors.white70 : Colors.black54),
          ),
          const SizedBox(
            height: 5,
          ),

          Text(
            ifscCode ?? "N/A",
            style: Get.textTheme.subtitle2?.copyWith(
                color: (isExpanded) ? Colors.white70 : Colors.black54),
          )
        ],
      ),
    );
  }

  Widget buildExpandedContent(
      {required bool isBankVerified,
      required VoidCallback onDelete,
      required VoidCallback onVerify,
      required VoidCallback onTransfer}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        const Divider(
          indent: 0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_forever),
              label: const Text("Delete"),
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
            ElevatedButton.icon(
              onPressed: onVerify,
              icon: Icon(Icons.verified_outlined,color: Get.theme.primaryColor,),
              label: Text((isBankVerified) ? "re-verify" : "verify",style: TextStyle(color: Get.theme.primaryColor),),
              style: ElevatedButton.styleFrom(primary: Colors.white,onSurface: Colors.white),
            ),
           /* ElevatedButton.icon(
              onPressed: onTransfer,
              icon: Transform.rotate(
                angle: 12,
                child: Icon(Icons.send),
              ),
              label: const Text("Transfer"),
              style: ElevatedButton.styleFrom(),
            ),*/
          ],
        ),
      ],
    );
  }

  Widget buildSendButton(bool isExpanded, VoidCallback onClick) {
    return Column(
      children: [
        InkResponse(
          onTap: onClick,
          child: CircleAvatar(
            backgroundColor:
                (isExpanded) ? Colors.white : Get.theme.primaryColorDark,
            radius: 22,
            child: Transform.rotate(
                angle: 5.7,
                child: Icon(
                  Icons.send,
                  color:
                      (isExpanded) ? Get.theme.primaryColorDark : Colors.white,
                )),
          ),
        ),
        Text(
          "send",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: (isExpanded) ? Colors.white : Colors.black),
        )
      ],
    );
  }
}
