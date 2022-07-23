import 'package:spayindia/model/common.dart';
import 'package:spayindia/model/user/signup/mobile_submit.dart';
import 'package:spayindia/model/wallet/wallet_fav.dart';

import '../../model/report/security_deposit.dart';

abstract class SecurityDepositRepo{
  Future<CommonResponse> addDeposit(data);
  Future<SecurityDepositReportResponse> fetchReport(data);
}