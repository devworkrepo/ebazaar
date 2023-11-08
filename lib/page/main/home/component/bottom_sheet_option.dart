import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:ebazaar/data/app_pref.dart';
import 'package:ebazaar/res/color.dart';
import 'package:ebazaar/widget/button.dart';

class AepsDialogWidget extends StatelessWidget {
  final VoidCallback onTramo;
  final VoidCallback onAirtel;

  const AepsDialogWidget(
      {Key? key, required this.onTramo, required this.onAirtel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appPreference = Get.find<AppPreference>();
    final user = appPreference.user;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            "assets/image/apes_server.png",
            height: 180,
            width: double.infinity,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "Which AEPS Server You Want To Select ?",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              if (user.isAeps ?? false)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green
                    ),
                      onPressed: () {
                        Get.back();
                        onTramo();
                      },
                      child: Text(
                        "AEPS - KING",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                ),
              if (user.is_aeps_air ?? false)
                const SizedBox(
                  width: 16,
                ),
              if (user.is_aeps_air ?? false)
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green
                    ),
                      onPressed: () {
                        Get.back();
                        onAirtel();
                      },
                      child: Text(
                        "AEPS - QUEEN",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      )),
                )
            ],
          )
        ],
      ),
    );
  }
}

class VirtualAccountOptionDialog extends StatelessWidget {
  final VoidCallback onAccountView;
  final VoidCallback onTransactionView;

  const VirtualAccountOptionDialog(
      {Key? key, required this.onAccountView, required this.onTransactionView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseOptionDialogWidget(
        title: "Virtual Account",
        option: [
          _BaseOption(
              title: "Virtual\nAccount View",
              onClick: onAccountView,
              svgName: "virtual_account"),
          _BaseOption(
              title: "Virtual\nTransaction View",
              onClick: onTransactionView,
              svgName: "virtual_account"),
        ],
        isSvg: false);
  }
}

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
        _BaseOption(
            title: "Mobile Prepaid",
            onClick: onPrepaidClick,
            svgName: "mobile"),
        _BaseOption(
            title: "Mobile Postpaid",
            onClick: onPostpaidClick,
            svgName: "mobile"),
      ],
    );
  }
}

class MatmOptionDialog extends StatelessWidget {
  final VoidCallback matmClick;
  final VoidCallback mposClick;

  const MatmOptionDialog(
      {Key? key, required this.matmClick, required this.mposClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _BaseOptionDialogWidget(
      title: "Mpos / Matm Services",
      option: [
        _BaseOption(title: "M-ATM", onClick: matmClick, svgName: "matm"),
        _BaseOption(title: "M-POS", onClick: mposClick, svgName: "matm"),
      ],
    );
  }
}

class _BaseOption {
  final VoidCallback onClick;
  final String title;
  final String svgName;

  _BaseOption(
      {required this.title, required this.onClick, required this.svgName});
}

class _BaseOptionDialogWidget extends StatelessWidget {
  final String title;
  final List<_BaseOption> option;
  final bool isSvg;

  const _BaseOptionDialogWidget(
      {Key? key, required this.title, required this.option, this.isSvg = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
            children: [
              ...option.map((e) => _BuildItem(
                    e.title,
                    e.svgName,
                    () {
                      Get.back();
                      e.onClick();
                    },
                    isSvg: isSvg,
                  ))
            ],
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
  final bool isSvg;

  const _BuildItem(this.title, this.svgName, this.onClick,
      {Key? key, this.isSvg = true})
      : super(key: key);

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
                    child: (isSvg)
                        ? SvgPicture.asset(
                            "assets/svg/$svgName.svg",
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/image/virtual_account.png",
                            ),
                          )),
                Text(
                  title,
                  style: Get.textTheme.subtitle2,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
