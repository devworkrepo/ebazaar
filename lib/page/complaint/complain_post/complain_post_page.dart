import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/util/validator.dart';
import 'package:spayindia/widget/button.dart';
import 'package:spayindia/widget/drop_down.dart';
import 'package:spayindia/widget/text_field.dart';

import 'complain_post_controller.dart';

class ComplainPostPage extends GetView<ComplainPostController> {
  const ComplainPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ComplainPostController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post New Complain"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/image/complaint.jpeg",
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(width: 12,),
                    Expanded(
                        child: Text(
                            "We are very sorry for your bad experience. Please, "
                                "spend some of your valuable time to write exactly "
                                "what happened so that we can take our steps as "
                                "soon as possible",style: TextStyle(
                          fontSize: 14,fontWeight: FontWeight.bold,height: 1.4,color: Colors.black.withOpacity(0.7)
                        ),))
                  ],
                ),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      Obx(() => AppDropDown(
                          selectedItem: (controller.categoryObs.value.isEmpty)
                              ? null
                              : controller.categoryObs.value,
                          hint: "Select Category",
                          label: "Category",
                          list: controller.complainCategoryList,
                          validator: (value){
                            if (controller.categoryObs.value.isEmpty) {
                              return "Select complain category";
                            } else {
                              return null;
                            }
                          },
                          onChange: (value) {
                            controller.categoryObs.value = value;
                          })),
                      AppTextField(
                        controller: controller.transactionNumberController,
                        hint: "Enter Transaction No.",
                        label: "Transaction Number",
                        validator: (value)=>FormValidatorHelper.empty(value,message: "Transaction number is required"),
                      ),
                      AppTextField(
                        controller: controller.subjectController,
                        hint: "Enter Subject",
                        label: "Subject",
                        validator: (value)=>FormValidatorHelper.empty(value,message: "Subject is required"),
                      ),
                      AppTextField(
                        controller: controller.noteController,
                        hint: "Write your issue",
                        label: "Issue",
                        validator: (value)=>FormValidatorHelper.empty(value,message: "Describe your issue"),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      AppButton(text: "Post Complain", onClick: () {
                        controller.postNewComplain();
                      })
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
