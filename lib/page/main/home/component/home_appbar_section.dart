import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/common/animate_icon_widget.dart';
import 'package:spayindia/res/color.dart';

class HomeAppbarSection extends StatelessWidget {
  final VoidCallback onDrawerOpen;

  const HomeAppbarSection({Key? key, required this.onDrawerOpen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          Card(
            color:Colors.white,
            shape : RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            child: IconButton(
                onPressed: onDrawerOpen,
                icon:  Icon(
                  Icons.menu,
                  size: 24,
                  color: Get.theme.primaryColorDark,
                )),
          ),
          const SizedBox(
            width: 12,
          ),
          AppAnimatedWidget(
            child: Image.asset(
              "assets/image/logo.png",
            ),
          ),
          const Spacer(),
          IconButton(
            color: Get.theme.primaryColorDark,
            iconSize: 32,
            onPressed: () {},
            icon: const Icon(Icons.notifications_active),
          ),
          IconButton(
            color: Get.theme.primaryColorDark,
            iconSize: 32,
            onPressed: () {},
            icon: const Icon(Icons.info),
          )
        ],
      ),
    );
  }
}
