import 'dart:convert';

import 'package:spayindia/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  final SharedPreferences _sharedPreferences;

  AppPreference(this._sharedPreferences);

  final _token = "token";
  final _user = "user";
  final _balance = "balance";
  final _isLoginCheck = "is_login_check";
  final _password = "password";
  final _mobileNumber = "mobile_number";
  final _isTransactionApi = "is_transaction_api";
  final _rdService = "rd_service";
  final _biometricServiceEnable = "biometric_service_enable";

  setPassword(String value) => _saveStringData(_password, value);

  String get password => _retrieveStringData(_password);

  setMobileNumber(String value) => _saveStringData(_mobileNumber, value);

  String get mobileNumber => _retrieveStringData(_mobileNumber);

  setSessionKey(String value) async {
    return await _saveStringData(_token, value);
  }

  String get sessionKey => _retrieveStringData(_token);


  setRdService(String value) async {
    return await _saveStringData(_rdService, value);
  }

  String get rdService => _retrieveStringData(_rdService);


  setUser(UserDetail value) async {
    String user = jsonEncode(value);
    return await _saveStringData(_user, user);
  }

  UserDetail get user {
    var json = jsonDecode(_retrieveStringData(_user));
    var user = UserDetail.fromJson(json);
    return user;
  }


  setIsTransactionApi(bool value) async {
    _saveBoolData(_isTransactionApi, value);
  }

  bool get isTransactionApi {
    return _retrieveBoolData(_isTransactionApi);
  }


  setIsLoginCheck(bool value) => _saveBoolData(_isLoginCheck, value);

  bool get isLoginCheck => _retrieveBoolData(_isLoginCheck);


  setBiometricAuthentication(bool value) => _saveBoolData(_biometricServiceEnable, value);

  bool get isBiometricAuthentication => _retrieveBoolData(_biometricServiceEnable,defaultValue: true);

  _saveStringData(String key, String value) =>
      _sharedPreferences.setString(key, value);

  _retrieveStringData(String key) => _sharedPreferences.getString(key) ?? "";

  _saveBoolData(String key, bool value) =>
      _sharedPreferences.setBool(key, value);

  _retrieveBoolData(String key,{bool defaultValue= false}) => _sharedPreferences.getBool(key) ?? defaultValue;

  Future<bool> logout() async {
    await setIsTransactionApi(false);
    await setUser(UserDetail.fromJson({
      "code" : 0,
      "message" :"",
      "status" : ""
    }));
    await setIsLoginCheck(false);
    await setPassword("");
    await setMobileNumber("");
    await setSessionKey("");
    return true;
  }
}

