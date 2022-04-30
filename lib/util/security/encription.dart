import 'package:encrypt/encrypt.dart';
import 'package:spayindia/util/app_util.dart';

import 'app_config.dart';

class Encryption {

  Encryption._();

  static String encryptMPIN(String text){
return text;
    if(text.isEmpty || text == "na"){
      return text;
    }
    return aesEncrypt(text);
  }

  static Future<String> getEncValue(String mobileNumber) async{
    final String deviceId = await AppUtil.getDeviceID();
    return aesEncrypt(deviceId+"_"+ deviceId+"_"+mobileNumber);
  }

  static String aesEncrypt(String valueToBeEncrypted) {
    final key = Key.fromUtf8(AppConfig.networkKey);
    final iv = IV.fromUtf8(AppConfig.networkKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: "PKCS7"));
    var encrypted = encrypter.encrypt(valueToBeEncrypted, iv: iv);
    var data =  encrypted.base64;
    AppUtil.logger("Encrypted data : $data");
    aepDecrypt(data);
    return data;
  }

  static String aepDecrypt(String valueToBeDecrypted) {
    final key = Key.fromUtf8(AppConfig.networkKey);
    final iv = IV.fromUtf8(AppConfig.networkKey);
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    var data = encrypter.decrypt(Encrypted.fromBase64(valueToBeDecrypted), iv: iv);
    AppUtil.logger("Decrypted data : $data");
    return data;
  }
}
