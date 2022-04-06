import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/component/text_field.dart';

class RefundBottomSheetDialog extends StatefulWidget {

  final Function(String) onProceed;
  const RefundBottomSheetDialog({required this.onProceed,Key? key}) : super(key: key);

  @override
  _RefundBottomSheetDialogState createState() =>
      _RefundBottomSheetDialogState();
}

class _RefundBottomSheetDialogState extends State<RefundBottomSheetDialog> {
  final mpinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key:  _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Take Refund",
                style: Get.textTheme.headline3
                    ?.copyWith(color: Get.theme.primaryColor),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: MPinTextField(controller: mpinController),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: AppButton(text: "Proceed", onClick: () {

                  if(_formKey.currentState!.validate()){
                    Get.back();
                    widget.onProceed(mpinController.text);
                  }

                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RefundButtonWidget extends StatelessWidget {
  final VoidCallback onClick;

  const RefundButtonWidget({required this.onClick, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(
              Icons.keyboard_return_sharp,
              color: Colors.black,
            ),
            Text(
              "Take Refund",
              style: TextStyle(color: Colors.black),
            )
          ],
        ));
  }
}
