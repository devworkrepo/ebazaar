import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';
import 'package:spayindia/model/common.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/service/network_client.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/util/picker_helper.dart';

class TestImagePicker extends StatefulWidget {
  const TestImagePicker({Key? key}) : super(key: key);

  @override
  _TestImagePickerState createState() => _TestImagePickerState();
}

class _TestImagePickerState extends State<TestImagePicker> {
  File? pickedImageFile;

  final NetworkClient _client = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test Image Picker"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Pick Image"),
            (pickedImageFile == null)
                ? ElevatedButton(
                    onPressed: () => _pickImage(),
                    child: const Text("Pick Image"))
                : Column(
                    children: [
                      Image.file(
                        pickedImageFile!,
                        height: 200,
                        width: 120,
                      ),
                      ElevatedButton(
                          onPressed: () => _uploadImage(),
                          child: const Text("Upload Image"))
                    ],
                  )
          ],
        ),
      ),
    );
  }

  _pickImage() async {
    ImagePickerHelper.pickImageWithCrop((File? image) {
      setState(() {
        pickedImageFile = image;
      });
    },(){});
  }

  _uploadImage() async {

   try{
     StatusDialog.progress(title: "Uploading");
     var param = await _uploadImageParam();
     var data = await _client.post("upload-image",data: param,options: Options(
         contentType : "application/json",
         headers: {
           "Accept" : "application/json"
         }
     ));
     Get.back();
     var response = StatusMessageResponse.fromJson(data.data);
     if(response.status == 1){
       StatusDialog.success(title: response.message);
     }
     else {
       StatusDialog.failure(title: response.message);
     }

   }catch(e){
     Get.back();
     Get.to(()=>ExceptionPage(error: e,));
   }

  }

  Future<dio.FormData> _uploadImageParam() async {
    dio.MultipartFile? fileData;
    fileData = await dio.MultipartFile.fromFile(pickedImageFile!.path,
        filename: "hello_dev2.png");

    AppUtil.logger("File Name : ${pickedImageFile!.path.split("/").last}");

    var param = {
      "image_file": fileData,
    };
    return dio.FormData.fromMap(param);
  }
}
