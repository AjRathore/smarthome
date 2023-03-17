import 'package:miriHome/models/device_type.dart';
import '../models/device_state.dart';

class IDevices {
  String displayName = "";
  String zigbeeFriendlyName = "";
  String ieeeAddress = "";
  String vendor = "";
  String model = "";
  String description = "";
  String image = "";
  String roomIdentifier = "";
  bool isDeviceSupported = false;
  DeviceType deviceType = DeviceType.Undefined;
  DeviceState state = DeviceState.undefined;

  IDevices.fromJson(Map<String, dynamic> json) {
    // displayName = json['displayName'];
    // zigbeeFriendlyName = json['zigbeeFriendlyName'];
    // deviceType = DeviceType.fromJson(json['deviceType']);
  }

  IDevices.fromMQTTJson(Map<String, dynamic> json) {
    displayName = json['displayName'] ?? "";
    zigbeeFriendlyName = json['friendly_name'];
    ieeeAddress = json['ieee_address'] ?? "ieeeAddress";
    if (json['definition'] != null) {
      vendor = json['definition']['vendor'];
      model = json['definition']['model'] ?? "model";
      description = json['definition']['description'] ?? "description";
    }
    isDeviceSupported = json['supported'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this.displayName;
    data['zigbeeFriendlyName'] = this.zigbeeFriendlyName;
    data['deviceType'] = this.deviceType;
    data['ieeeAddress'] = this.ieeeAddress;
    data['vendor'] = this.vendor;
    data['model'] = this.model;
    data['description'] = this.description;
    data['isDeviceSupported'] = this.isDeviceSupported;
    data['image'] = this.image;
    data['roomIdentifier'] = this.roomIdentifier;
    return data;
  }

  void UpdateDevice(IDevices devices) {}
}
