import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/res/style.dart';

class EkycInfoWidget extends StatelessWidget {
  final VoidCallback onClick;
  final VoidCallback onCancel;

  const EkycInfoWidget(
      {required this.onClick, required this.onCancel, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        onCancel();
        return false;
      },
      child: Container(
        decoration: AppStyle.bottomSheetDecoration(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "E-Kyc is Pending",
                style: Get.textTheme.headline4,
              ),
              const SizedBox(height: 16,),
               Text(
                  "E-Kyc is required for AEPS, Aadhaar Pay and Micro Atm transaction. Without doing it you will not granted for further transaction",
              style: Get.textTheme.bodyText1,),
              const SizedBox(height: 32,),
              AppButton(text: "Do E-Kyc", onClick: onClick),
              const SizedBox(height: 16,),
              AppButton(text: "Cancel", onClick: onCancel,background: Colors.red,),
            ],
          ),
        ),
      ),
    );
  }
}
