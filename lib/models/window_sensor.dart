import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/interfaces/idevices.dart';

class WindowSensor implements IDevices {
  late String windowSensorName;
  late bool contact = false;
  late num battery;

  WindowSensor(IDevices device) {
    this.displayName = device.displayName;
    this.zigbeeFriendlyName = device.zigbeeFriendlyName;
    this.state = state;
    this.deviceType = deviceType;
    this.description = device.description;
    this.model = device.model;
    this.image = "https://www.zigbee2mqtt.io/images/devices/${model}.jpg";
    this.vendor = device.vendor;
    this.roomIdentifier = device.roomIdentifier;
    this.ieeeAddress = device.ieeeAddress;
    this.isDeviceSupported = isDeviceSupported;
    this.contact = true;
    this.battery = 23.5;
  }

  @override
  late String displayName;

  @override
  DeviceType deviceType = DeviceType.Sensor;

  @override
  late String zigbeeFriendlyName;

  @override
  DeviceState state = DeviceState.undefined;

  @override
  late String description;

  @override
  late String ieeeAddress;

  @override
  bool isDeviceSupported = false;

  @override
  late String model;

  @override
  late String vendor;

  @override
  String image = "";

  @override
  late String roomIdentifier;

  UpdateWindowSensorContact(bool contact) {
    this.contact = contact;
  }

  @override
  WindowSensor.fromJson(Map<String, dynamic> json)
      : battery = json['battery'] ?? 2,
        contact = json['contact'] ?? false,
        displayName = json['displayName'] ?? "Window",
        zigbeeFriendlyName = json['zigbeeFriendlyName'] ?? "ZigbeeWindow",
        deviceType = DeviceType.values.byName(json['deviceType']),
        ieeeAddress = json['ieeeAddress'] ?? "ieeeAddress",
        vendor = json['vendor'] ?? "vendor",
        model = json['model'] ?? "model",
        description = json['description'] ?? "description",
        isDeviceSupported = json['isDeviceSupported'] ?? false,
        image = json['image'] ?? "",
        roomIdentifier = json['roomIdentifier'] ?? "";

  WindowSensor.fromMQTTJson(Map<String, dynamic> json)
      : battery = json['battery'] ?? 2,
        contact = json['contact'] ?? false,
        displayName = json['displayName'] ?? "Window",
        zigbeeFriendlyName = json['zigbeeFriendlyName'] ?? "ZigbeeWindow",
        deviceType = DeviceType.values.byName(json['deviceType']);

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
    var windowSensor = devices as WindowSensor;
    this.contact = windowSensor.contact;
  }
}
