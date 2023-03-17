import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/interfaces/idevices.dart';

class Lamp implements IDevices {
  Lamp(IDevices device) {
    this.displayName = device.displayName;
    this.zigbeeFriendlyName = device.zigbeeFriendlyName;
    this.state = state;
    this.deviceType = deviceType;
    this.description = device.description;
    this.model = device.model;
    this.image = "https://www.zigbee2mqtt.io/images/devices/${model}.jpg";
    this.vendor = device.vendor;
    this.ieeeAddress = device.ieeeAddress;
    this.roomIdentifier = device.roomIdentifier;
    this.isDeviceSupported = isDeviceSupported;
    this.state = state;
  }

  @override
  late String displayName;

  @override
  late DeviceType deviceType = DeviceType.Lamp;

  @override
  Lamp.fromJson(Map<String, dynamic> json)
      : state =
            json['state'].toString() == "ON" ? DeviceState.on : DeviceState.off,
        displayName = json['displayName'] ?? "Lamp",
        zigbeeFriendlyName = json['zigbeeFriendlyName'] ?? "ZigbeeLamp",
        deviceType = DeviceType.values.byName(json['deviceType']),
        ieeeAddress = json['ieeeAddress'] ?? "ieeeAddress",
        vendor = json['vendor'] ?? "vendor",
        model = json['model'] ?? "model",
        description = json['description'] ?? "description",
        isDeviceSupported = json['isDeviceSupported'] ?? false,
        image = json['image'] ?? "",
        roomIdentifier = json['roomIdentifier'] ?? "";

  Lamp.fromMQTTJson(Map<String, dynamic> json)
      : state =
            json['state'].toString() == "ON" ? DeviceState.on : DeviceState.off;

  UpdateLamp(DeviceState state) {
    this.state = state;
  }

  @override
  late String zigbeeFriendlyName;

  @override
  DeviceState state = DeviceState.off;

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'zigbeeFriendlyName': zigbeeFriendlyName,
        'deviceType': deviceType,
        'ieeeAddress': ieeeAddress,
        'vendor': vendor,
        'model': model,
        'description': description,
        'isDeviceSupported': isDeviceSupported,
        'image': image,
        'roomIdentifier': roomIdentifier
      };

  @override
  void UpdateDevice(IDevices devices) {
    var lamp = devices as Lamp;

    this.state = lamp.state;
  }

  @override
  late String description;

  @override
  late String ieeeAddress;

  @override
  bool isDeviceSupported = false;

  @override
  String model = "";

  @override
  late String vendor;

  @override
  String image = "";

  @override
  late String roomIdentifier;
}
