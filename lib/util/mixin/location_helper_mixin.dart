import 'package:geolocator/geolocator.dart';
import 'package:spayindia/widget/common.dart';
import 'package:spayindia/service/location.dart';

mixin LocationHelperMixin {
  Position? position;

  Future<bool> validateLocation({bool progress = true}) async {
    if (position != null) {
      return true;
    }

    try {
      position = await LocationService.determinePosition(progress: progress);
      return (position == null) ? false : true;
    } catch (e) {
      showFailureSnackbar(
          title: "Location Required",
          message: "Unable to fetch location! Please try again.");
      return false;
    }
  }
}
