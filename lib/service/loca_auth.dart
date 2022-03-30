import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthService {
  static Future<bool> checkBiometric() async {
    try {
      bool canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
      return canCheckBiometrics;
      /* AppUtil.logger("LocalAuthTest : $canCheckBiometrics");

      if (canCheckBiometrics) {
        List<BiometricType> availableBiometrics =
            await LocalAuthentication().getAvailableBiometrics();

        if (availableBiometrics.contains(BiometricType.face)) {
          return true;
        } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
          return true;
        } else {
          return false;
        }
      }
      else{
        return false;
      }*/
    } catch (e) {
      return false;
    }
  }

  static Future<bool> authenticate() async {
    if(await checkBiometric()){
      try {
        var isAuthenticate = await LocalAuthentication().authenticate(
            stickyAuth: true,
            localizedReason:
            "Access app with biometric authentication is more secure");

        if (!isAuthenticate) {
          SystemNavigator.pop();
          return false;
        }
        else{
          return true;
        }
      } catch (e) {
        return false;
      }
    }
    else{
      return false;
    }
  }
}
