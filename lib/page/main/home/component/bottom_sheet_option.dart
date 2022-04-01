import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spayindia/res/color.dart';

class RechargeOptionDialog extends StatelessWidget {
  final VoidCallback onPrepaidClick;
  final VoidCallback onPostpaidClick;

  const RechargeOptionDialog(
      {Key? key, required this.onPostpaidClick, required this.onPrepaidClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseOptionDialogWidget(
      title: "Recharge Type",
      option: [
        _BaseOption(title: "Mobile Prepaid", onClick: onPrepaidClick,svgName: "mobile"),
        _BaseOption(title: "Mobile Postpaid", onClick: onPostpaidClick,svgName: "mobile"),
      ],
    );
  }
}

class AepsOptionDialog extends StatelessWidget {
  final VoidCallback onAepsClick;
  final VoidCallback onAadhaarPayClick;

  const AepsOptionDialog(
      {Key? key, required this.onAepsClick, required this.onAadhaarPayClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseOptionDialogWidget(
      title: "AEPS Type",
      option: [
        _BaseOption(title: "AEPS", onClick: onAepsClick,svgName: "aeps"),
        _BaseOption(title: "Aadhaar Pay", onClick: onAadhaarPayClick,svgName: "aeps"),
      ],
    );
  }
}

class _BaseOption {
  final VoidCallback onClick;
  final String title;
  final String svgName;

  _BaseOption({required this.title, required this.onClick,required this.svgName});
}

class _BaseOptionDialogWidget extends StatelessWidget {
  final String title;
  final List<_BaseOption> option;

  const _BaseOptionDialogWidget(
      {Key? key, required this.title, required this.option})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      padding: const EdgeInsets.all(16),
      decoration:  BoxDecoration(
          color: AppColor.backgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(12))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Get.textTheme.headline6,
            ),
          ),
          Row(
            children: [...option.map((e) => _BuildItem(e.title,e.svgName,(){
              Get.back();
              e.onClick();
            }))],
          ),
        ],
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  final String title;
  final String svgName;
  final VoidCallback onClick;

  const _BuildItem(this.title,this.svgName, this.onClick, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onClick,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 60,
                    child: SvgPicture.asset("assets/home/$svgName.svg",)),
                Text(
                  title,
                  style: Get.textTheme.bodyText1,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
