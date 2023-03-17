import 'package:miriHome/models/device_state.dart';
import 'package:miriHome/models/device_type.dart';
import 'package:miriHome/interfaces/idevices.dart';

class TempSensor implements IDevices {
  late double temperatureValue;
  late double humidityValue;
  late int battery = 90;

  @override
  late String displayName;

  @override
  DeviceType deviceType = DeviceType.TemperatureSensor;

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

  @override
  late String zigbeeFriendlyName;

  @override
  DeviceState state = DeviceState.undefined;

  TempSensor(IDevices device) {
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
    this.temperatureValue = 10.0;
    this.humidityValue = 10.0;
    this.battery = battery;
    this.isDeviceSupported = isDeviceSupported;
  }

  @override
  TempSensor.fromJson(Map<String, dynamic> json)
      : temperatureValue =
            double.tryParse(json["temperature"].toString()) ?? 5.0,
        humidityValue = double.tryParse(json["humidity"].toString()) ?? 5.0,
        battery = json['battery'] ?? 90,
        displayName = json['displayName'] ?? "TempSensor",
        zigbeeFriendlyName = json['zigbeeFriendlyName'] ?? "ZigbeeTemp",
        deviceType = DeviceType.values.byName(json['deviceType']),
        ieeeAddress = json['ieeeAddress'] ?? "ieeeAddress",
        vendor = json['vendor'] ?? "vendor",
        model = json['model'] ?? "model",
        description = json['description'] ?? "description",
        isDeviceSupported = json['isDeviceSupported'] ?? false,
        image = json['image'] ?? "",
        roomIdentifier = json['roomIdentifier'] ?? "";

  @override
  void UpdateDevice(IDevices devices) {
    var tempDevice = devices as TempSensor;
    this.temperatureValue = tempDevice.temperatureValue;
    this.humidityValue = tempDevice.humidityValue;
    this.battery = tempDevice.battery;
  }

  TempSensor.fromMQTTJson(Map<String, dynamic> json)
      : temperatureValue =
            double.tryParse(json["temperature"].toString()) ?? 5.0,
        humidityValue = double.tryParse(json["humidity"].toString()) ?? 5.0,
        battery = json['battery'] ?? 90;

  UpdateTempSensor(double temperature, double humidiy, int battery) {
    this.temperatureValue = temperature;
    this.humidityValue = humidiy;
    this.battery = battery;
  }

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
}
