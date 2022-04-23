import 'package:flutter/material.dart';
import 'package:spayindia/service/local_auth.dart';
import 'package:spayindia/util/app_util.dart';

class TestLocalAuthPage extends StatelessWidget {
  const TestLocalAuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test Local Auth"),
      ),
      body: Center(
        child: ElevatedButton(onPressed: () async{

         var isBiometric =await LocalAuthService.isAvailable();
         AppUtil.logger("isBiometric : $isBiometric");

         if(isBiometric){
           LocalAuthService.authenticate();
         }

        }, child: Text("Click Test")),
      ),
    );
  }
}
