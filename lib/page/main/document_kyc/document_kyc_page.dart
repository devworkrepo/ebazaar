import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/api_component.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/document_kyc/document_kyc_controller.dart';

class DocumentKycPage extends GetView<DocumentKycController> {
  const DocumentKycPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(DocumentKycController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document Kyc"),
      ),
      body: Obx(() => controller.documentListResponseObs.value.when(
          onSuccess: (data) {
            if (data.status == 1) {
              return _buildBody();
            } else {
              return ExceptionPage(error: Exception(data.message));
            }
          },
          onFailure: (e) => ExceptionPage(error: e),
          onInit: (data) => ApiProgress(data))),
    );
  }

  _buildBody() {
    return SizedBox(
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      _BuildItem(
                        title: "Pan Card Front",
                        status:
                            controller.documentKycDetail!.panCardImageStatus,
                        imageUrl: controller.documentKycDetail!.panCardImage,
                        onUpload: () => controller.onUpload(DocumentKycFileType.panCardImage),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.panCardImage),
                      ),
                      _BuildItem(
                        title: "Profile Photo",
                        status:
                            controller.documentKycDetail!.profileImageStatus,
                        imageUrl: controller.documentKycDetail!.profilePicture,
                        onUpload: () => controller.onUpload(DocumentKycFileType.profilePicture),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.profilePicture),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      _BuildItem(
                        title: "Aadhaar Front",
                        status: controller
                            .documentKycDetail!.aadhaarFrontImageStatus,
                        imageUrl:
                            controller.documentKycDetail!.aadhaarCardImage,
                        onUpload: () => controller.onUpload(DocumentKycFileType.aadhaarCardImage),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.aadhaarCardImage),
                      ),
                      _BuildItem(
                        title: "Aadhaar Back",
                        status: controller
                            .documentKycDetail!.aadhaarBackImageStatus,
                        imageUrl: controller.documentKycDetail!.aadhaarImgBack,
                        onUpload: () => controller.onUpload(DocumentKycFileType.aadhaarCardBankImage),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.aadhaarImgBack),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      _BuildItem(
                        title: "Shop Image",
                        status: controller.documentKycDetail!.shopImageStatus,
                        imageUrl: controller.documentKycDetail!.shopImage,
                        onUpload: () => controller.onUpload(DocumentKycFileType.shopImage),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.shopImage),
                      ),
                      _BuildItem(
                        title: "Cancel Cheque",
                        status: controller.documentKycDetail!.chequeImageStatus,
                        imageUrl: controller.documentKycDetail!.chequeImage,
                        onUpload: () => controller.onUpload(DocumentKycFileType.chequeImage),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.chequeImage),
                      )
                    ],
                  ),
                  Row(
                    children: [

                      _BuildItem(
                        title: "Gst Image",
                        status: controller.documentKycDetail!.gstImageStatus,
                        imageUrl: controller.documentKycDetail!.gstImage,
                        onUpload: () => controller.onUpload(DocumentKycFileType.gstImage),
                        onViewImage: () => controller.onImageView(controller.documentKycDetail!.gstImage),
                      ),
                      const Expanded(child: SizedBox())
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  final String title;
  final String status;
  final String imageUrl;
  final VoidCallback onUpload;
  final VoidCallback onViewImage;

  const _BuildItem(
      {Key? key,
      required this.title,
      required this.onUpload,
      required this.status,
      required this.imageUrl,
      required this.onViewImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: (status == "0") ? onUpload : onViewImage,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            DottedBorder(
              strokeWidth: 1.5,
              color: Colors.grey,
              dashPattern: [12, 5],
              borderType: BorderType.RRect,
              radius: const Radius.circular(8),
              padding: const EdgeInsets.all(8),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: SizedBox(
                  width: Get.width,
                  height: 216,
                  child: (status == "0")
                      ? _buildUploadWidget()
                      : _buildUploadedWidget(),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  _buildUploadedWidget() {
    Color color = Colors.black54;
    String statusTitle = "Unknown";
    if (status == "0") {
      color = Colors.black54;
      statusTitle = "Upload";
    } else if (status == "1") {
      color = Colors.green;
      statusTitle = "Approved";
    } else if (status == "2") {
      color = Colors.red;
      statusTitle = "Rejected";
    } else if (status == "3") {
      color = Colors.yellow[900]!;
      statusTitle = "Scanning...";
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle_outline_outlined,
                  color: Colors.grey,
                  size: 40,
                ),
                const Text(
                  "File Uploaded",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  statusTitle,
                  style: Get.textTheme.subtitle1?.copyWith(color: color),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "(Tap to view image)",
                  style: Get.textTheme.bodyText2?.copyWith(color: Colors.blue),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              title,
              style: Get.textTheme.subtitle2?.copyWith(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }

  _buildUploadWidget() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.cloud_upload,
                  size: 100,
                  color: Colors.grey,
                ),
                Text(
                  "Upload",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              title,
              style: Get.textTheme.subtitle2?.copyWith(color: Colors.black54),
            ),
          )
        ],
      ),
    );
  }
}
