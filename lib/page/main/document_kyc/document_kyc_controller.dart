import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:spayindia/component/common/confirm_amount_dialog.dart';
import 'package:spayindia/component/dialog/status_dialog.dart';
import 'package:spayindia/data/repo/aeps_repo.dart';
import 'package:spayindia/data/repo_impl/aeps_repo_impl.dart';
import 'package:spayindia/model/kyc/document_kyc_list.dart';
import 'package:spayindia/page/main/document_kyc/image_view_dialog.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/picker_helper.dart';

import '../../exception_page.dart';

class DocumentKycController extends GetxController {
  AepsRepo repo = Get.find<AepsRepoImpl>();

  var documentListResponseObs =
      Resource.onInit(data: DocumentKycDetailResponse()).obs;
  DocumentKycDetail? documentKycDetail;

  @override
  void onInit() {
    _fetchDocuments();
    super.onInit();
  }

  _fetchDocuments() async {
    try {
      documentListResponseObs.value = const Resource.onInit();
      var response = await repo.fetchKycDocumentDetails();
      if (response.status == 1) {
        documentKycDetail = response.data;
      }
      documentListResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      documentListResponseObs.value = Resource.onFailure(e);
    }
  }

  onUpload(DocumentKycFileType fileType) {
    ImagePickerHelper.pickImageWithCrop((file) {
      if (file == null) return;

      Get.dialog(AmountConfirmDialogWidget(
          title: "Confirm Upload File ?",
          description:
              "Please make sure! you are uploading correct document file.",
          onConfirm: () {
            _uploadFile(file, fileType);
          }));
    });
  }

  onImageView(String imageUrl) {
    Get.dialog(DocumentKycImageViewDialog(imageUrl: imageUrl));
  }

  _uploadFile(File? file, DocumentKycFileType fileType) async {
    StatusDialog.progress();
    try {
      var response = await repo
          .documentKycUploadFile(await _uploadFileParam(file, fileType));
      Get.back();
      if (response.status == 1) {
        StatusDialog.success(title: response.message)
            .then((value) => _fetchDocuments());
      } else {
        StatusDialog.failure(title: response.message);
      }
    } catch (e) {
      Get.back();
      AppUtil.logger(e.toString());
      Get.to(()=>ExceptionPage(
          error: Exception("Error while uploading, to check refresh the page"
              " or try with different "
              "image(capture using phone camera)")));
    }
  }

  _getMultipartFormData(File? file) async {
    if (file == null) return file;
    var fileData = await dio.MultipartFile.fromFile(file.path,
        filename: file.path.split("/").last);
    return fileData;
  }

  Future<dio.FormData> _uploadFileParam(
      File? file, DocumentKycFileType fileType) async {
    dio.MultipartFile? shopImageFile;
    dio.MultipartFile? profilePictureFile;
    dio.MultipartFile? panCardImageFile;
    dio.MultipartFile? aadhaarFrontImageFile;
    dio.MultipartFile? aadhaarBackImageFile;
    dio.MultipartFile? chequeImageFile;
    dio.MultipartFile? gstImageFile;
    dio.MultipartFile? sealImageFile;

    switch (fileType) {
      case DocumentKycFileType.shopImage:
        shopImageFile =await  _getMultipartFormData(file);
        break;
      case DocumentKycFileType.profilePicture:
        profilePictureFile = await _getMultipartFormData(file);
        break;
      case DocumentKycFileType.panCardImage:
        panCardImageFile =await  _getMultipartFormData(file);
        break;
      case DocumentKycFileType.aadhaarCardImage:
        aadhaarFrontImageFile =await  _getMultipartFormData(file);
        break;
      case DocumentKycFileType.aadhaarCardBankImage:
        aadhaarBackImageFile =await  _getMultipartFormData(file);
        break;
      case DocumentKycFileType.chequeImage:
        chequeImageFile =await  _getMultipartFormData(file);
        break;
      case DocumentKycFileType.gstImage:
        gstImageFile =await  _getMultipartFormData(file);
        break;
      case DocumentKycFileType.sealImage:
        sealImageFile =await  _getMultipartFormData(file);
        break;
    }

    int imageHeight = 0;
    var imageWidth = 0;

    if (file != null) {
      var imageHeightWidth =
          await ImagePickerHelper.getHeightWidthOfImageFile(file);
      imageHeight = imageHeightWidth["height"] ?? 500;
      imageWidth = imageHeightWidth["width"] ?? 300;
    }

    var param = {
      "shop_image": shopImageFile,
      "profile_picture": profilePictureFile,
      "pan_card_image": panCardImageFile,
      "aadhaar_card_image": aadhaarFrontImageFile,
      "aadhaar_img_back": aadhaarBackImageFile,
      "cheque_image": chequeImageFile,
      "gst_image": gstImageFile,
      "seal_image": sealImageFile,
      "image_height": imageHeight,
      "image_width": imageWidth
    };
    return dio.FormData.fromMap(param);
  }
}

enum DocumentKycFileType {
  shopImage,
  profilePicture,
  panCardImage,
  aadhaarCardImage,
  aadhaarCardBankImage,
  chequeImage,
  gstImage,
  sealImage
}