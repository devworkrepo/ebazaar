import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

class LogoutConfirmDialog extends StatelessWidget {
  final Function onConfirm;

  const LogoutConfirmDialog({
    required this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseDialogContainer(
      backPress: true,
      padding: 30,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            _buildCrossButton(),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleWidget(),
                _buildDescription(),
                _buildConfirmButtonWidget()
              ],
            )
          ],
        ),
      ),
    );
  }

  _buildDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        "Are you sure! to logout from application. It will delete all login data",
        textAlign: TextAlign.center,
        style: Get.textTheme.subtitle1,
      ),
    );
  }



  _buildConfirmButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: AppButton(
          text: "Logout",
          onClick: () {
            Get.back();
            onConfirm();
          }),
    );
  }


  _buildTitleWidget() {
    return Text(
      "Logout ",
      style: Get.textTheme.headline3,
    );
  }

  _buildCrossButton() {
    return Positioned(
        top: 0,
        right: 0,
        child: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.cancel,
            size: 32,
            color: Colors.red,
          ),
        ));
  }
}
