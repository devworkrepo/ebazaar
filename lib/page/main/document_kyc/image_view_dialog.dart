import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentKycImageViewDialog extends StatelessWidget {

  final String imageUrl;

  const DocumentKycImageViewDialog({Key? key,required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image View"),
      ),
      body: SizedBox(
        height: Get.height,
        width: Get.width,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
