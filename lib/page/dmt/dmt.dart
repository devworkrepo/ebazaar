enum DmtType{
  instantPay
}


class DmtHelper{
  static String getAppbarTitle(DmtType dmtType) {
    if (dmtType == DmtType.instantPay) {
      return "Money Transfer";
    }else {
      return "Not Implemented Type";
    }
  }

}

enum DmtTransferType{
  imps, neft
}