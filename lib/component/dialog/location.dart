import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spayindia/component/button.dart';
import 'package:spayindia/service/location.dart';
import 'package:share/share.dart';

class LocationDialog extends StatelessWidget {

  final LocationError locationError;

  const LocationDialog({Key? key, required this.locationError})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var locationData = _getLocationMessageAndIcon();

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Icon(locationData["icon"],size: 80,color: Colors.red,),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(

                    locationData["message"],
                    textAlign: TextAlign.center,
                    style:
                    Get.textTheme.headline4?.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          (locationError == LocationError.permissionIsPermanentlyDenied) ? Positioned(
              bottom: 10,
              right: 5,
              left: 5,
              child: AppButton(text: "Go to App Setting", onClick:(){
                AppSettings.openAppSettings();

              })) : const SizedBox()
        ],
      ),
    );
  }


  _getLocationMessageAndIcon() {
    if (locationError == LocationError.locationNotEnable) {
      return {
        "message": "Location service is not enable, please enable the service to continue",
        "icon": Icons.location_disabled
      };
    }

    if (locationError == LocationError.permissionIsDenied) {
      return {
        "message": "Sorry! service is not available without location, you have just denied the permissions",
        "icon": Icons.location_disabled
      };
    }
    if (locationError == LocationError.permissionIsPermanentlyDenied) {
      return {
        "message": "Sorry! service is not available without location, goto to App Setting and grant the permissions",
        "icon": Icons.location_disabled
      };
    }
  }

}
