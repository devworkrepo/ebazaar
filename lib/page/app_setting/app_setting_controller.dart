import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/service/local_auth.dart';

class AppSettingController extends GetxController{
  AppPreference appPreference = Get.find();

  var isBiometricLoginEnable = false.obs;
  var biometricDescriptionText = "".obs;

  @override
  void onInit() {
    super.onInit();
    setupInitialBiometric();
    getBiometricDescription();
  }

  setupInitialBiometric() async {
    var value = await LocalAuthService.isAvailable();
    if (value) {
      isBiometricLoginEnable.value = appPreference.isBiometricAuthentication;
    } else {
      isBiometricLoginEnable.value = false;
    }
  }

  setBiometricLogin(bool value) async {
    var mValue = await LocalAuthService.isAvailable();
    if(mValue){
      isBiometricLoginEnable.value = value;
      appPreference.setBiometricAuthentication(value);
    }
    else{
      isBiometricLoginEnable.value = false;
    }
  }

  getBiometricDescription() async {
    var isBiometricAvailable = await LocalAuthService.isAvailable();
    var text =
        "Your device doesn't support biometric authentication or it may be disable from screen lock security setting. To access spay app without login with otp every time please enable phone screen lock security. For more support please call our helpline number";

    if (!isBiometricAvailable) {
      biometricDescriptionText.value = text;
    } else {
      biometricDescriptionText.value = "";
    }
  }
}