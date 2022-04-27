
import 'package:spayindia/util/app_util.dart';

class FormValidatorHelper {


  static String? normalValidation(value,{int minLength=3}) {
    var msg = "Enter min $minLength characters";
    if (value == null) {
      return msg;
    } else {
      if (value.length >= minLength) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? passwordValidation(value) {
    var msg = "Enter min 6 characters password";
    if (value == null) {
      return msg;
    } else {
      if (value.length >= 6) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? emailValidation(value) {

    if(value == null) {
      return "Field can't be empty!";
    }
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);

    if(emailValid){
      return null;
    }
    else {
      return "Enter email with valid format";
    }
  }

  static String? otpValidation(value, {int digit = 4}) {
    var msg = "Enter $digit digits Otp";
    if (value == null) {
      return msg;
    } else {
      if (value.length == digit) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? mobileNumberValidation(value) {
    var msg = "Enter 10 digits mobile number";
    if (value == null) {
      return msg;
    } else {
      if (value.length == 10) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? amount(String? value, {int minAmount = 10,int maxAmount = 10000}) {
    var msg = "Enter amount in range of $minAmount to $maxAmount";
    if (value == null) {
      return msg;
    }
    else {
      try {
        var amount = double.parse(value);
        if (amount >=minAmount && amount <=maxAmount) {
          return null;
        } else {
          return msg;
        }
      } catch (e) {
        AppUtil.logger(e.toString());
        return msg;
      }
    }
  }


  static String? empty(String? value) {
    var msg = "Field can't be empty!";
    if (value == null) {
      return msg;
    } else {
      if (value.isNotEmpty) {
        return null;
      } else {
        return msg;
      }
    }
  }

  static String? mpin(String? value, {int length = 4}) {
    var msg = "Enter $length digits MPIN";
    if (value == null) {
      return msg;
    } else {
      if (value.length == length) {
        return null;
      } else {
        return msg;
      }
    }
  }
}
