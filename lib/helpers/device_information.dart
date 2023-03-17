import 'dart:io';
import 'package:device_info/device_info.dart';

class DeviceInformation {
  Future<String> getDeviceInfo() async {
    String identifier = "DefaultIdentifier";
    try {
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        identifier = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
        identifier = iosInfo.identifierForVendor;
      }
    } catch (e) {
      print("Exception in devices_information.dart - getDeviceInfo - $e");
    }
    return identifier;
  }
}
