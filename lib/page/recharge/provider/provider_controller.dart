import 'package:get/get.dart';
import 'package:spayindia/data/app_pref.dart';
import 'package:spayindia/data/repo/recharge_repo.dart';
import 'package:spayindia/data/repo_impl/recharge_repo_impl.dart';
import 'package:spayindia/model/recharge/provider.dart';
import 'package:spayindia/model/recharge/response.dart';
import 'package:spayindia/page/exception_page.dart';
import 'package:spayindia/page/main/home/home_controller.dart';
import 'package:spayindia/route/route_name.dart';
import 'package:spayindia/util/api/resource/resource.dart';
import 'package:spayindia/util/app_util.dart';

class ProviderController extends GetxController {
  ProviderType providerType = Get.arguments;
  var providerTypeObs = ProviderType.prepaid.obs;

  RechargeRepo repo = Get.find<RechargeRepoImpl>();

  AppPreference appPreference = Get.find();

  var providerResponseObs = Resource
      .onInit(data: ProviderResponse())
      .obs;

  late ProviderResponse providerResponse;

  List<Provider> providerList = <Provider>[];

  @override
  void onInit() {
    super.onInit();
    providerTypeObs.value = providerType;
    _fetchProviders();
  }

  _fetchProviders() async {
    try {
      providerResponseObs.value = const Resource.onInit();

      ProviderResponse response = await repo.fetchProviders({
        "type": getProviderInfo(providerType)?.requestParam ?? "",
      });

      if (response.code == 1) {
        providerList = response.providers!;
        searchProviderListObs.value = providerList;
        providerResponse = response;
      }

      providerResponseObs.value = Resource.onSuccess(response);
    } catch (e) {
      providerResponseObs.value = Resource.onFailure(e);
      Get.to(()=>ExceptionPage(error: e));
    }
  }

  onItemClick(Provider provider) {
    var arguments = {
      "provider": provider,
      "provider_type": providerType,
      "provider_name": getProviderInfo(providerType)?.name ?? "",
      "provider_image": getProviderInfo(providerType)?.imageName ?? "",
    };

    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.prepaid ||
        providerType == ProviderType.dth) {
      Get.toNamed(RouteName.rechargePage, arguments: arguments);
    } else {
      Get.toNamed(RouteName.billPaymentPage, arguments: arguments);
    }
  }

  RxList<Provider> searchProviderListObs = <Provider>[].obs;

  onSearchChange(String value) async {
    List<Provider> results = providerList;
    if (value.isEmpty) {
      AppUtil.logger(providerList.toString());

      results = providerList;
    } else {
      results = providerList
          .where(
              (user) => user.name.toLowerCase().startsWith(value.toLowerCase()))
          .toList();
    }
    searchProviderListObs.value = results;
  }

  bool showSearchOption() {
    if (providerType == ProviderType.prepaid ||
        providerType == ProviderType.postpaid ||
        providerType == ProviderType.dth ||
        providerType == ProviderType.landline) {
      return false;
    } else {
      return true;
    }
  }


  showBillType() {
    return (providerType == ProviderType.postpaid ||
        providerType == ProviderType.prepaid ||
        providerType == ProviderType.insurance ||
        providerType == ProviderType.dth) ? false : true;
  }

  onBillTypeSelect(ProviderType type) {
    providerType = type;
    providerTypeObs.value = type;
    _fetchProviders();
  }

}


class ProviderInfo {
  late String name;
  late String imageName;
  late String requestParam;

  ProviderInfo(this.name, this.requestParam, this.imageName);
}

ProviderInfo? getProviderInfo(ProviderType type) {
  switch (type) {
    case ProviderType.prepaid:
      return ProviderInfo("Prepaid", "prepaid", "mobile");
    case ProviderType.postpaid:
      return ProviderInfo("Postpaid", "Postpaid", "mobile");
    case ProviderType.dth:
      return ProviderInfo("Dth", "dth", "dth");
    case ProviderType.electricity:
      return ProviderInfo("Electricity", "electricity", "electricity");
    case ProviderType.water:
      return ProviderInfo("Water", "water", "water");
    case ProviderType.gas:
      return ProviderInfo("Gas", "gas", "gas");
    case ProviderType.landline:
      return ProviderInfo("Telephone", "broadbank", "landline");
    case ProviderType.insurance:
      return ProviderInfo("Insurance", "insurance", "insurance");
    default:
      return null;
  }
}