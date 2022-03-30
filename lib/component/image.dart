import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:spayindia/res/color.dart';
import 'package:spayindia/util/hex_color.dart';

class AppCircleNetworkImage extends StatelessWidget {
  final String imageUrl;
  final int horizontalPadding;
  final int size;

  const AppCircleNetworkImage(this.imageUrl,
      {this.horizontalPadding = 12, this.size = 50, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      decoration: BoxDecoration(
        color: AppColor.backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Container(
        height: size.toDouble(),
        width: size.toDouble(),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(
              imageUrl,
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      padding: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(color: HexColor("ECF8FD"), shape: BoxShape.circle),
      child: Image.network(
        imageUrl,
        height: size.toDouble(),
        width: size.toDouble(),
      ),
    );
  }
}




class AppCircleAssetImage extends StatelessWidget {
  final String imagePath;
  final int horizontalPadding;

  const AppCircleAssetImage(this.imagePath, {this.horizontalPadding = 12,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      padding: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(color: HexColor("fff6f5"), shape: BoxShape.circle),
      child: Image.asset(
        imagePath,
        color: Get.theme.primaryColorDark,
        height: 50,
        width: 50,
      ),
    );
  }
}

class AppCircleAssetSvg extends StatelessWidget {
  final String imagePath;
  final int horizontalPadding;
  final Color? backgroundColor;

  const AppCircleAssetSvg(this.imagePath,
      {this.horizontalPadding = 12, Key? key, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding.toDouble()),
      padding: const EdgeInsets.all(4),
      decoration:
          BoxDecoration(color: backgroundColor ?? HexColor("E0F6FF"), shape: BoxShape.circle),
      child: SvgPicture.asset(
        imagePath,
        height: 50,
        width: 50,
      ),
    );
  }
}
