import 'package:geolocator/geolocator.dart';
import 'package:spayindia/widget/common.dart';
import 'package:spayindia/service/location.dart';
import 'package:spayindia/widget/dialog/status_dialog.dart';

import '../../service/location.dart';

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
      if (e is LocationError) {
        if (e == LocationError.permissionIsDenied) {
          await StatusDialog.alert(title: "Permission denied! please grant the permission to access further features.");
        }
        else if(e  == LocationError.locationNotEnable){
          await StatusDialog.alert(title: "Location not enable! please enable location to access further feature");
        }
      }
      return false;
    }
  }
}
