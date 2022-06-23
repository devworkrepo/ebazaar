import 'package:flutter/material.dart';
import 'package:spayindia/service/native_call.dart';
import 'package:spayindia/util/app_util.dart';
import 'package:spayindia/widget/button.dart';


class TestCredoPayPage extends StatelessWidget {
  const TestCredoPayPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CredoPay"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("Credo Pay"),
            AppButton(text: "Launch", onClick: (){
             try{
               NativeCall.credoPayService("");
             }catch(e){
               AppUtil.logger("CredoPayError : ${e.toString()}");
             }
            })
          ],
        ),
      ),
    );
  }
}
