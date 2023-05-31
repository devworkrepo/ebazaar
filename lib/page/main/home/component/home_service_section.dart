import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/widget/image.dart';
import 'package:spayindia/model/user/user.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/util/etns/on_bool.dart';

class HomeServiceSection extends GetView<HomeController> {
  final Function(HomeServiceItem) onClick;

  const HomeServiceSection({Key? key, required this.onClick}) : super(key: key);

  _svgPicture(name, int innerPadding) {
    return AppCircleAssetSvg(
      "assets/svg/$name.svg",
      size: 60,
      innerPadding: innerPadding,
    );
  }

  _pngPicture(name, int innerPadding) {
    return AppCircleAssetPng(
      "assets/image/$name.png",
      size: 60,
      innerPadding: innerPadding,
    );
  }

  _buildItem(String iconName, String title, HomeServiceType homeServiceType,
      {int innerPadding = 4}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        (homeServiceType == HomeServiceType.creditCard ||
                homeServiceType == HomeServiceType.lic ||
                homeServiceType == HomeServiceType.ott ||
                homeServiceType == HomeServiceType.virtualAccount ||
                homeServiceType == HomeServiceType.securityDeposity ||
                homeServiceType == HomeServiceType.fundAddOnline ||
                homeServiceType == HomeServiceType.upiPayment ||
                homeServiceType == HomeServiceType.cms ||
                homeServiceType == HomeServiceType.newInvestment ||
                homeServiceType == HomeServiceType.paytmWallet
        )
            ? _pngPicture(iconName, innerPadding)
            : _svgPicture(iconName, innerPadding),
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var homeServiceList = _homeServiceList(controller.user);
    var itemCount = homeServiceList.length;
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 12, left: 12, right: 12),
      child: Card(
        child: GridView.count(
          shrinkWrap: true,
          padding: const EdgeInsets.all(8),
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          children: List.generate(
            itemCount,
            (index) => _gridTile(homeServiceList[index], index),
          ),
        ),
      ),
    );
  }

  Widget _gridTile(HomeServiceItem item, int index) {
    return GestureDetector(
      onTap: () {
        if (item.homeServiceType != HomeServiceType.none) {
          onClick(item);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                color: (index == 0 || index == 1 || index == 2)
                    ? Colors.transparent
                    : Colors.black54,
                width: 0.5,
              ),
              left: BorderSide(
                color: (index == 0 || index % 3 == 0)
                    ? Colors.transparent
                    : Colors.black54,
                width: 0.5,
              )),
        ),
        child: Center(
          child: (item.homeServiceType != HomeServiceType.none)
              ? _buildItem(item.iconName, item.title, item.homeServiceType,
                  innerPadding: innerPadding(item))
              : const SizedBox(),
        ),
      ),
    );
  }

  int innerPadding(HomeServiceItem item) {
    if (item.homeServiceType == HomeServiceType.walletPay ||
        item.homeServiceType == HomeServiceType.virtualAccount) {
      return 12;
    } else if (item.homeServiceType == HomeServiceType.lic) {
      return 16;
    } else if (item.homeServiceType == HomeServiceType.paytmWallet) {
      return 13;
    } else if (item.homeServiceType == HomeServiceType.aadhaarPay ||
        item.homeServiceType == HomeServiceType.aeps) {
      return 10;
    } else {
      return 8;
    }
  }
}

enum HomeServiceType {
  moneyTransfer,
  payoutTransfer,
  matm,
  aeps,
  aadhaarPay,
  recharge,
  dth,
  billPayment,
  partBillPayment,
  walletPay,
  insurance,
  creditCard,
  lic,
  paytmWallet,
  ott,
  virtualAccount,
  securityDeposity,
  fundAddOnline,
  upiPayment,
  cms,
  newInvestment,
  none
}

class HomeServiceItem {
  final String title;
  final String iconName;
  final HomeServiceType homeServiceType;

  HomeServiceItem(this.title, this.iconName, this.homeServiceType);
}

List<HomeServiceItem> _homeServiceList(UserDetail user) {
  var isMatm = user.isMatm ?? false;
  var isMatmCredo = user.is_matm_credo ?? false;
  var isMposCredo = user.is_mpos_credo ?? false;

  List<HomeServiceItem> itemList = [];

  itemList.add(HomeServiceItem(
      "Money Transfer", "money", HomeServiceType.moneyTransfer));

  if (user.isPayout.orFalse()) {
    itemList.add(HomeServiceItem(
        "Payout Transfer", "money", HomeServiceType.payoutTransfer));
  }
  if (isMatm || isMatmCredo || isMposCredo) {
    itemList.add(HomeServiceItem(
        ((isMatm || isMatmCredo) && isMposCredo)
            ? "Matm / Mpos"
            : (isMposCredo)
                ? "Mpos"
                : "Matm",
        "matm",
        HomeServiceType.matm));
  }
  if (user.isAeps.orFalse()) {
    itemList.add(
        HomeServiceItem("Aadhaar Pay", "aeps", HomeServiceType.aadhaarPay));
  }
  if (user.isAeps.orFalse() || user.is_aeps_air.orFalse()) {
    itemList.add(HomeServiceItem("Aeps", "aeps", HomeServiceType.aeps));
  }
  if (user.isRecharge.orFalse()) {
    itemList.add(HomeServiceItem(
        "Mobile\nRecharge", "mobile", HomeServiceType.recharge));
  }
  if (user.isDth.orFalse()) {
    itemList.add(HomeServiceItem("DTH\nRecharge", "dth", HomeServiceType.dth));
  }
  if (user.isBill.orFalse()) {
    itemList.add(HomeServiceItem(
        "Bill\nPayment", "electricity", HomeServiceType.billPayment));
  }
  if (user.isBillPart.orFalse()) {
    itemList.add(HomeServiceItem(
        "Part Bill\nPayment", "electricity", HomeServiceType.partBillPayment));
  }
  if (user.isWalletPay.orFalse()) {
    itemList.add(
        HomeServiceItem("Wallet Pay", "wallet", HomeServiceType.walletPay));
  }
  if (user.isInsurance.orFalse()) {
    itemList.add(HomeServiceItem(
        "Loan\nInsurance", "insurance", HomeServiceType.insurance));
  }

  if (user.isCreditCard.orFalse()) {
    itemList.add(HomeServiceItem(
        "Pay Credit\nCard Bill", "card", HomeServiceType.creditCard));
  }
  if (user.isLic.orFalse()) {
    itemList.add(HomeServiceItem("LIC\nPremium", "lic", HomeServiceType.lic));
  }
  if (user.isPaytmWallet.orFalse()) {
    itemList.add(HomeServiceItem(
        "Load Paytm\nWallet", "paytm", HomeServiceType.paytmWallet));
  }
  if (user.isOtt.orFalse()) {
    itemList
        .add(HomeServiceItem("OTT\nSubscription", "ott", HomeServiceType.ott));
  }

  if (user.isVirtualAccount ?? false) {
    itemList.add(HomeServiceItem(
        "Virtual\nAccount", "virtual_account", HomeServiceType.virtualAccount));
  }

  if (user.isSecurityDeposit ?? false) {
    itemList.add(HomeServiceItem("Security\nDeposit", "security_deposit",
        HomeServiceType.securityDeposity));
  }


  if (user.is_pg ?? false) {
    itemList.add(HomeServiceItem("Add Fund\nOnline", "fund_add_online",
        HomeServiceType.fundAddOnline));
  }

 /* if (true) {
    itemList.add(HomeServiceItem("UPI\nPayment", "upi_payment",
        HomeServiceType.upiPayment));
  }
*/
  if (user.is_cmsv2 ?? false) {
    itemList.add(HomeServiceItem("CMS\nService", "cms_service",
        HomeServiceType.cms));
  }

  //todo remove hardcoded true for new investment
  if ( true) {
    itemList.add(HomeServiceItem("New\nInvestment", "credit_money",
        HomeServiceType.newInvestment));
  }



  var length = itemList.length;

  if (length == 3 ||
      length == 6 ||
      length == 9 ||
      length == 12 ||
      length == 15 ||
      length == 18) {
  } else if (length == 2 ||
      length == 5 ||
      length == 8 ||
      length == 11 ||
      length == 14 ||
      length == 17) {
    itemList.add(HomeServiceItem("", "", HomeServiceType.none));
  } else if (length == 1 ||
      length == 4 ||
      length == 7 ||
      length == 10 ||
      length == 13 ||
      length == 16) {
    itemList.add(HomeServiceItem("", "", HomeServiceType.none));
    itemList.add(HomeServiceItem("", "", HomeServiceType.none));
  }

  return itemList;
}
