import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:spayindia/widget/common/image_picker_dialog.dart';
import 'package:spayindia/util/app_util.dart';

class ImagePickerHelper {
  static final ImagePicker _imagePicker = ImagePicker();

  static pickImageWithCrop(Function(File?) onPick) {
    Get.bottomSheet(ImagePickerSourceWidget(
      onSelect: (ImageSource source) async {
        File? file = await _pickAndCrop(source);
        onPick(file);
      },
    ));
  }

  static Future<File?> _pickAndCrop(ImageSource source) async {
    XFile? image = await _imagePicker.pickImage(source: source);

    if (image == null) {
      var sourceInString = (source == ImageSource.gallery)
          ? "Failed to pick image from Gallery"
          : "Failed to take image from camera";

      Get.snackbar("Please try again", sourceInString,
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    } else {
      print("File Size after capture : " +
          (await getFileSizeInKb(image.path)).toString());

      File? file = await compressImage(image.path);

     // var fileImageFile = await _cropImage(file?.path);

      var fixRotationFile = await fixRotation(file!.path);

      return fixRotationFile;
    }
  }

  static Future<File?> fixRotation(String filePath) async {
    final img.Image? capturedImage =
        img.decodeImage(await File(filePath).readAsBytes());
    final img.Image orientedImage = img.bakeOrientation(capturedImage!);
    return await File(filePath).writeAsBytes(img.encodeJpg(orientedImage));
  }

  static Future<File?> compressImage(String filePath) async {
    try {
      var fileSize = await getFileSizeInKb(filePath);
      int compressValue = 100;
      if (fileSize > 0 && fileSize < 500) {
        compressValue = 95;
      } else if (fileSize > 500 && fileSize < 100) {
        compressValue = 90;
      } else if (fileSize > 1000 && fileSize < 1500) {
        compressValue = 80;
      } else if (fileSize > 1500 && fileSize < 2000) {
        compressValue = 75;
      } else if (fileSize > 2000 && fileSize < 2500) {
        compressValue = 70;
      } else if (fileSize > 2500 && fileSize < 3000) {
        compressValue = 65;
      } else if (fileSize > 3000 && fileSize < 4000) {
        compressValue = 60;
      } else if (fileSize > 4000 && fileSize < 8000) {
        compressValue = 50;
      } else {
        compressValue = 40;
      }

      var newPath = path.join((await getTemporaryDirectory()).path,
          "${DateTime.now()}.${path.extension(filePath)}");
      File? file = await FlutterImageCompress.compressAndGetFile(
          filePath, newPath,
          quality: compressValue);

      print("File Size after compress1 : " +
          (await getFileSizeInKb(file!.path)).toString());

      return file;
    } catch (e) {
      print("File Size after compress2 : " +
          (await getFileSizeInKb(filePath)).toString());
      return File(filePath);
    }
  }

  static Future<File?> _cropImage(String? filePath) async {
    if (filePath == null) return null;

    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: filePath,
        aspectRatio: const CropAspectRatio(ratioX: 9, ratioY: 16),
        androidUiSettings: AndroidUiSettings(
            statusBarColor: Get.theme.primaryColorDark,
            toolbarColor: Get.theme.primaryColor,
            toolbarWidgetColor: Colors.white,
            toolbarTitle: "Crop Image"));
    if (croppedFile == null) {
      Get.snackbar("Please try again", "Crop processing failed!",
          backgroundColor: Colors.red, colorText: Colors.white);
      return null;
    }

    print("File Size after crop : " +
        (await getFileSizeInKb(croppedFile.path)).toString());

    return croppedFile;
  }

  static Future<double> getFileSizeInKb(String? filePath) async {
    if(filePath == null) return 0.0;
    var sizeInB =  File(filePath).lengthSync();
    var sizeInKB = sizeInB / 1024;
    return sizeInKB;
  }

  getFileSize(String filepath, int decimals) async {
    var file = File(filepath);
    int bytes = await file.length();
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

 static Future<Map<String, int>> getHeightWidthOfImageFile(File file) async {
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());

    AppUtil.logger("Height : " + decodedImage.width.toString());
    AppUtil.logger("Width : " + decodedImage.height.toString());

    var newHeight = (decodedImage.width > decodedImage.height)
        ? decodedImage.width
        : decodedImage.height;
    var newWidth = (decodedImage.width < decodedImage.height)
        ? decodedImage.width
        : decodedImage.height;

    return {"height": newHeight, "width": newWidth};
  }
}
